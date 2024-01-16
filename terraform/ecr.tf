resource "aws_ecr_repository" "ecr_repo_1" {
  name = "tms-frontend-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_repo_2" {
  name = "tms-users-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_repo_3" {
  name = "tms-logout-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_repo_4" {
  name = "tms-mysql-job-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}
