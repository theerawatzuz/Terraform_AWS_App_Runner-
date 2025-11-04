resource "aws_apprunner_service" "app_service" {
  service_name = "${var.project_name}-svc"

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.auto_config.arn

  source_configuration {
    auto_deployments_enabled = true

    

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access_role.arn
    }

    image_repository {
       image_identifier      = local.image_uri  
      image_repository_type = "ECR"

      image_configuration {
        port          = "3000"
        start_command = "node main.js"

        runtime_environment_variables = {
          APP_VERSION = var.app_version
        }
      }
    }
  }

    health_check_configuration {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 1
    unhealthy_threshold = 5
    interval            = 5
    timeout             = 2
  }



  tags = {
    Name = "${var.project_name}-apprunner"
  }
}

output "service_url" {
  value = aws_apprunner_service.app_service.service_url
}