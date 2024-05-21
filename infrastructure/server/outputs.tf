output "api_url" {
  description = "Update API URL"
  value       = "${aws_api_gateway_deployment.db.invoke_url}/${aws_api_gateway_resource.db.path_part}"
}
