variable "jenkins_values" {
  type    = string
  default = <<EOF
    controller:
      # Jenkins controller configuration (resources, annotations, etc.)
      resources:
        requests:
          cpu: "500m"
          memory: "512Mi"
        limits:
          cpu: "1"
          memory: "1024Mi"
      serviceType: LoadBalancer
      # Additional Jenkins configurations...
    EOF
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "4.12.0"
  cleanup_on_fail  = true
  namespace        = "jenkins"
  create_namespace = true

  values = [var.jenkins_values]

  depends_on = [module.eks.cluster_id]
}
