output "invoke_arn" {
  value       = aws_lambda_function.main.invoke_arn
  description = "The ARN to invoke the lambda function"
}
