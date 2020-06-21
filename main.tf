# main.tf

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  environment = var.environment
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}

module "ec2_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  environment = var.environment
  delimiter   = var.delimiter
  attributes  = concat(var.attributes, ["instance"])
  tags        = var.tags
}

###############
## INSTANCE ##
#############

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["aws-storage-gateway-*"]
  }
}

// NOTE: Ingress / Egress rules taken from AWS:
// https://docs.aws.amazon.com/storagegateway/latest/userguide/Resource_Ports.html
resource "aws_security_group" "this" {
  name        = module.label.id
  description = "Security Group for NFS File Gateway."
  vpc_id      = var.vpc_id
  tags        = module.label.tags

  // Activation
  //////////////
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.ingress_cidr_blocks
  }

  // NFS
  ///////
  ingress {
    protocol    = "tcp"
    from_port   = 20048
    to_port     = 20048
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "udp"
    from_port   = 20048
    to_port     = 20048
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "tcp"
    from_port   = 111
    to_port     = 111
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "udp"
    from_port   = 111
    to_port     = 111
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "udp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = var.ingress_cidr_blocks
  }

  // DNS (?)
  ///////////
  ingress {
    protocol    = "tcp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    protocol    = "udp"
    from_port   = 53
    to_port     = 53
    cidr_blocks = var.ingress_cidr_blocks
  }

  // Allow all egress
  ////////////////////
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  vpc      = true
  tags     = module.label.tags
}

resource "aws_instance" "this" {
  ami                         = var.ami != "" ? var.ami : data.aws_ami.this.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  tags                        = module.ec2_label.tags
}

resource "aws_ebs_volume" "this" {
  availability_zone = aws_instance.this.availability_zone
  size              = var.volume_size
  type              = var.volume_type
  encrypted         = true
  tags              = module.ec2_label.tags
}

resource "aws_volume_attachment" "this" {
  device_name  = var.volume_device_name
  volume_id    = aws_ebs_volume.this.id
  instance_id  = aws_instance.this.id
  force_detach = false
}

######################
## STORAGE GATEWAY ##
####################

resource "aws_storagegateway_gateway" "this" {
  gateway_ip_address = aws_eip.this.public_ip
  gateway_name       = module.label.id
  gateway_timezone   = var.gateway_timezone
  gateway_type       = "FILE_S3"
  tags               = module.label.tags
}

resource "aws_storagegateway_nfs_file_share" "this" {
  client_list  = var.client_list
  location_arn = var.bucket_arn
  gateway_arn  = aws_storagegateway_gateway.this.arn
  role_arn     = aws_iam_role.this.arn
  tags         = module.label.tags
}

data "aws_storagegateway_local_disk" "this" {
  depends_on  = [aws_volume_attachment.this]
  disk_node   = aws_volume_attachment.this.device_name
  gateway_arn = aws_storagegateway_gateway.this.arn
}

resource "aws_storagegateway_cache" "this" {
  disk_id     = data.aws_storagegateway_local_disk.this.id
  gateway_arn = aws_storagegateway_gateway.this.arn
}

###############
## IAM ROLE ##
#############

resource "aws_iam_role" "this" {
  name               = module.label.id
  assume_role_policy = data.aws_iam_policy_document.service_role.json
}

resource "aws_iam_policy" "this" {
  policy = data.aws_iam_policy_document.bucket_access.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "service_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["storagegateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bucket_access" {
  statement {
    sid       = "AllowStorageGatewayBucketTopLevelAccess"
    effect    = "Allow"
    resources = [var.bucket_arn]
    actions = [
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:ListBucketMultipartUploads"
    ]
  }

  statement {
    sid       = "AllowStorageGatewayBucketObjectLevelAccess"
    effect    = "Allow"
    resources = ["${var.bucket_arn}/*"]
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
  }
}
