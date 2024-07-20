resource "aws_lambda_function" "my-func" {
  filename         = data.archive_file.zip_the_python_code.output_path
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256
  function_name    = "my-func"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "my-func.handler"
  runtime          = "python3.8"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_cloud_resume_project" {

  name        = "aws_iam_policy_for_terraform_cloud_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the cloud resume project role"
    policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
			      "dynamodb:GetItem"
          ],
          "Resource" : "arn:aws:dynamodb:*:*:table/cloudresume-api"
        },
      ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_cloud_resume_project.arn

}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/my-func.py"
  output_path = "${path.module}/lambda/my-func.zip"
}
