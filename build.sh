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
rds_endpoint=$(terraform output -raw rds_cluster_endpoint)
db_username=$(terraform output -raw db_username)
db_password=$(terraform output -raw db_password)
cd ..
# Docker images name
frontend_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$frontend_img:latest"
users_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$users_img:latest"
logout_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$logout_img:latest"
job_image_name="$aws_id.dkr.ecr.eu-central-1.amazonaws.com/$mysql_job_img:latest"
# K8s
namespace="tms-app"
monitoring_ns="monitoring"
jenkins_ns="jenkins"
jenkins_service_name="jenkins"
argo_ns="argocd"
argo_service_name="argocd-server"
ingress_service_name="tms-ingress"
alertmanager_service_name="kube-prometheus-stack-alertmanager"
prometheus_service_name="kube-prometheus-stack-prometheus"
grafana_service_name="kube-prometheus-stack-grafana"
# End Variables

# update helm repos
helm repo update

# create the cluster
echo "--------------------Creating EKS--------------------"
echo "--------------------Creating ECR--------------------"
echo "--------------------Creating EBS--------------------"
echo "--------------------Creating RDS--------------------"
echo "--------------------Deploying Monitoring--------------------"
cd terraform && \
terraform init 
terraform apply -auto-approve
cd ..

# update kubeconfig
echo "--------------------Update Kubeconfig--------------------"
aws eks update-kubeconfig --name $cluster_name --region $region

# remove preious docker images
echo "--------------------Remove Previous build--------------------"
docker rmi -f $frontend_image_name || true
docker rmi -f $users_image_name || true
docker rmi -f $logout_image_name || true
docker rmi -f $job_image_name || true

# build new docker image with new tag
echo "--------------------Build new Image--------------------"
docker build -f task-management-system/frontend.Dockerfile -t $frontend_image_name task-management-system/
docker build -f task-management-system/users.Dockerfile -t $users_image_name task-management-system/
docker build -f task-management-system/logout.Dockerfile -t $logout_image_name task-management-system/
docker build -f k8s/mysql.Dockerfile -t $job_image_name k8s/

# ECR Login
echo "--------------------Login to ECR--------------------"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_id.dkr.ecr.eu-central-1.amazonaws.com

# push the latest build to dockerhub
echo "--------------------Pushing Docker Image--------------------"
docker push $frontend_image_name
docker push $users_image_name
docker push $logout_image_name
docker push $job_image_name

# create namespace
echo "--------------------creating Namespace--------------------"
kubectl create ns $namespace || true

# add rds endpoint into k8s secrets
echo "--------------------Create RDS Secrets --------------------"
kubectl create secret -n $namespace generic rds-endpoint --from-literal=endpoint=$rds_endpoint || true
kubectl create secret -n $namespace generic rds-username --from-literal=username=$db_username || true
kubectl create secret -n $namespace generic rds-password --from-literal=password=$db_password || true

# deploy the application
echo "--------------------Deploy App--------------------"
kubectl apply -n $namespace -f k8s/

# Wait for application to be deployed
echo "--------------------Wait for all pods to be running--------------------"
sleep 60s

# Get ingress URL
echo "--------------------Application LoadBalancer URL--------------------"
kubectl get ingress -n ${namespace} ${ingress_service_name} -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo " "
echo "-------------------- Jenkins URL--------------------"
kubectl get svc -n ${jenkins_ns} ${jenkins_service_name} -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo " "
echo "-------------------- ArgoCD URL--------------------"
kubectl get svc -n ${argo_ns} ${argo_service_name} -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo " "
echo "-------------------- Alertmanager URL--------------------"
kubectl get svc -n ${monitoring_ns} ${alertmanager_service_name} -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo " "
echo "--------------------Prometheus URL--------------------"
kubectl get svc -n ${monitoring_ns} ${prometheus_service_name} -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo " "
echo "--------------------Grafana URL--------------------"
kubectl get svc -n ${monitoring_ns} ${grafana_service_name} -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo " "
# Get RDS endpoint URL
echo "--------------------RDS endpoint URL--------------------"
echo $rds_endpoint