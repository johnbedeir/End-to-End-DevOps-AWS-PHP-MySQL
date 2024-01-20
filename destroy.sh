#!/bin/bash

# Variables
# AWS
cluster_name="cluster-1-test"
region="eu-central-1"
aws_id="702551696126"
# Store Terraform output in variables
cd terraform 
frontend_img=$(terraform output -raw ecr_app_repository_frontend) 
users_img=$(terraform output -raw ecr_app_repository_users) 
logout_img=$(terraform output -raw ecr_app_repository_logout)
mysql_job_img=$(terraform output -raw ecr_app_repository_mysql)
cd ..
# Docker images name
frontend_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$frontend_img:latest"
users_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$users_img:latest"
logout_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$logout_img:latest"
job_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$mysql_job_img:latest"
rds_snapshot_name=$(terraform output -raw final_snapshot_name)

# remove preious docker images
echo "--------------------Remove Previous build--------------------"
docker rmi -f $frontend_image_name || true
docker rmi -f $users_image_name || true
docker rmi -f $logout_image_name || true
docker rmi -f $job_image_name || true

# delete Docker-img from ECR
echo "--------------------Deleting ECR-IMG--------------------"
./ecr-imgs-delete.sh $frontend_img $region 
./ecr-imgs-delete.sh $users_img $region 
./ecr-imgs-delete.sh $logout_img $region
./ecr-imgs-delete.sh $mysql_job_img $region

# Destroy Infrastructure
# echo "--------------------Destroy Infrastructure--------------------"
cd terraform && \ 
terraform destroy -auto-approve

# Delete rds snapshot
echo "--------------------Delete Rds Snapshot--------------------"
aws rds delete-db-cluster-snapshot --db-cluster-snapshot-identifier $rds_snapshot_name --region $region

# Destroy the remaning infrastructure
echo "--------------------Destroy Remaining Infrastructure--------------------"
terraform destroy -auto-approve

