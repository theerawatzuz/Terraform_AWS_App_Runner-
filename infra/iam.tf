data "aws_iam_policy_document" "apprunner_ecr_access_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "apprunner_ecr_access_role" {
  name               = "${var.project_name}-apprunner-ecr-access"
  assume_role_policy = data.aws_iam_policy_document.apprunner_ecr_access_trust.json
}
resource "aws_iam_role_policy_attachment" "apprunner_ecr_pull" {
  role       = aws_iam_role.apprunner_ecr_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# (ถ้าแอปต้องเรียก AWS API จากในคอนเทนเนอร์จริง ๆ ค่อยใช้ role นี้)
data "aws_iam_policy_document" "apprunner_instance_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["tasks.apprunner.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "apprunner_instance_role" {
  name               = "${var.project_name}-apprunner-instance"
  assume_role_policy = data.aws_iam_policy_document.apprunner_instance_trust.json
}