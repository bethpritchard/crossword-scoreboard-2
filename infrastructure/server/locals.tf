locals {
  project            = "crossword-scoreboard"
  lambda_source_path = "../../lambdas"
  artifacts_path     = "${local.lambda_source_path}/dist"
}