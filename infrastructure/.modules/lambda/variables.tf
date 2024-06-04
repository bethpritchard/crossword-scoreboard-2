variable "lambda_iam_policy_arn" {
  description = "The arn of the IAM policy to attach to the lambda role"
  type        = string
}

variable "lambda_name" {
  description = "The name of the lambda function"
  type        = string

}

variable "lambda_source_path" {
  description = "The path to the lambda source code"
  type        = string
}

variable "handler_name" {
  description = "The name of the handler function"
  type        = string
  default     = "main.lambda_handler"
}

variable "lambda_runtime" {
  description = "The runtime for the lambda function"
  type        = string
  default     = "python3.8"
}

variable "api_gateway_arn" {
  description = "The arn of the api gateway"
  type        = string
}

variable "table_name" {
  description = "The name of the dynamodb table"
  type        = string
}
