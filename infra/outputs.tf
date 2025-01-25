output "ansible_control_public_ip" {
  value       = aws_instance.ansible_control.public_ip
  description = "Public IP of the Ansible control instance"
}

output "alb_dns_name" {
  value       = aws_lb.http_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "control_plane_private_ip" {
  value       = aws_instance.control_plane.private_ip
  description = "Private IP of the K8s control plane"
}

output "worker_nodes_private_ips" {
  value       = [for w in aws_instance.workers : w.private_ip]
  description = "Private IPs of the worker nodes"
}
