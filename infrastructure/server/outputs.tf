output "api_url" {
  description = "Update API URL"
  value       = "${aws_api_gateway_deployment.update.invoke_url}/${aws_api_gateway_resource.update.path_part}"
}
