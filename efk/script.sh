
# Prerequisites
# 1. Deploy EKS Cluster and connect to it
# 2. Install ebs-csi-driver add-on on aws eks console
# 3. Attach the AmazonEBSCSIDriverPolicy IAM Policy to the EKS Node Instance Role

# 4. Add helm repo
helm repo add elastic https://helm.elastic.co
helm repo update

# 5. Install elasticsearch
helm upgrade --install elasticsearch elastic/elasticsearch --version 8.5.1 --namespace logging --create-namespace set replicas=3

# 6. Install kibana
helm upgrade --install kibana elastic/kibana --version 8.5.1 --namespace logging

# 7. Install fluentd
kubectl apply -f fluentd.yaml

---
# // Uninstall kibana
helm uninstall kibana --namespace logging
# // Uninstall elasticsearch
helm uninstall elasticsearch --namespace logging
# // Uninstall fluentd
kubectl delete -f fluentd.yaml




