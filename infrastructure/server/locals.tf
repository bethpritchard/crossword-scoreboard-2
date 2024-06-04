locals {
  project            = "crossword-scoreboard"
  prefix             = "${var.environment}-${local.project}"
  lambda_source_path = "../../lambdas"
  artifacts_path     = "${local.lambda_source_path}/dist"
}
