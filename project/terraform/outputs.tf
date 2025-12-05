# outputs.tf - show ALB DNS after apply

output "alb_dns" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app_alb.dns_name
}
