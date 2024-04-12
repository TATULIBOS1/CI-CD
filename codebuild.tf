resource "aws_codebuild_project" "tatulibos" {
  name          = "tatulibos"
  description   = "Tatulibos CodeBuild Project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "" //account id
    }
    environment_variable {
      name  = "REPOSITORY_URI"
      value = ""//repository uri:latest
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/TATULIBOS1/backend.git" // backend source
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }
}

