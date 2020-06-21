# outputs.tf

output "eip_public_ip" {
  value       = aws_eip.this.public_ip
  description = "The Public IP address of the created Elastic IP."
}

output "instance_id" {
  value       = aws_instance.this.id
  description = "The ID of the created EC2 File Gateway instance."
}

output "instance_arn" {
  value       = aws_instance.this.arn
  description = "The ARN of the created EC2 File Gateway instance."
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "The ID of the created Security Group for the File Gateway's instance."
}

output "storage_gateway_arn" {
  value       = aws_storagegateway_gateway.this.arn
  description = "The ARN of the created Storage Gateway File Gateway."
}

output "storage_gateway_id" {
  value       = aws_storagegateway_gateway.this.gateway_id
  description = "The ID of the created Storage Gateway File Gateway."
}

output "nfs_arn" {
  value       = aws_storagegateway_nfs_file_share.this.arn
  description = "The ARN of the created NFS File Share."
}

output "nfs_id" {
  value       = aws_storagegateway_nfs_file_share.this.fileshare_id
  description = "The ID of the created NFS File Share."
}

output "nfs_path" {
  value       = aws_storagegateway_nfs_file_share.this.path
  description = "The file share path used by the NFS client to identify the mount point."
}

