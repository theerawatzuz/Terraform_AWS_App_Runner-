resource "aws_apprunner_auto_scaling_configuration_version" "auto_config" {
  auto_scaling_configuration_name = "${var.project_name}-autoscale"
  min_size                        = var.apprunner_min_size
  max_size                        = var.apprunner_max_size
  # You can add more settings like concurrency, etc
}