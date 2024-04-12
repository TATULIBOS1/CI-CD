resource "aws_codepipeline" "tatulibos_pipeline" {
  name     = "tatulibos-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.tatulicicd.bucket
    type     = "S3"
  }

  stage {
  name = "Source"

  action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        FullRepositoryId = "TATULIBOS1/backend"
        BranchName       = "main"
        ConnectionArn    = "" //codestar connection arn
        OutputArtifactFormat = "CODE_ZIP"
      }
  }
}

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.tatulibos.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = "my-ecs-cluster"
        ServiceName = "my-service"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
