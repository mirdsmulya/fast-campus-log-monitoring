
# Prerequisites
# 1. Deploy EKS Cluster and connect to it
# 2. Install ebs-csi-driver add-on on aws eks console
# 3. Attach the AmazonEBSCSIDriverPolicy IAM Policy to the EKS Node Instance Role

# create bucket
aws s3api create-bucket --bucket fastcampus-loki --region ap-southeast-1 --create-bucket-configuration LocationConstraint=ap-southeast-1
# create roles
aws iam create-role --role-name loki-role --assume-role-policy-document file://aws-setup/trust-policy.json
# create policy
aws iam create-policy --policy-name LokiS3AccessPolicy --policy-document file://aws-setup/s3-access-policy.json
# attach policy to roles
aws iam attach-role-policy --role-name loki-role --policy-arn arn:aws:iam::675327529402:policy/LokiS3AccessPolicy

# deploy grafana loki
kubectl create namespace monitoring
helm upgrade --install grafana ./grafana -f grafana/values-staging.yaml  --namespace monitoring 
helm upgrade --install loki ./loki -f loki/values.yaml  --namespace monitoring
helm upgrade --install promtail ./promtail -f promtail/values.yaml  --namespace monitoring



# remove

helm uninstall grafana --namespace monitoring
helm uninstall loki --namespace monitoring
helm uninstall promtail --namespace monitoring

# Detach policy from role
aws iam detach-role-policy --role-name loki-role --policy-arn arn:aws:iam::675327529402:policy/LokiS3AccessPolicy
# Delete policy
aws iam delete-policy --policy-arn arn:aws:iam::675327529402:policy/LokiS3AccessPolicy
# Delete role
aws iam delete-role --role-name loki-role