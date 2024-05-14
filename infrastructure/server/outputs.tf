output "api_url" {
  description = "Test API URL"
  value       = "${aws_api_gateway_deployment.test.invoke_url}/${aws_api_gateway_resource.test.path_part}"
}
