

# 1. install ebs-csi-driver
# 2. Attach the Required IAM Policy to the Node Instance Role
# 3. Add helm repo
helm repo add elastic https://helm.elastic.co
helm repo update

# 4. Install elasticsearch
helm upgrade --install elasticsearch elastic/elasticsearch --version 8.5.1 --namespace logging --create-namespace set replicas=3


# 5. Install kibana
helm upgrade --install kibana elastic/kibana --version 8.5.1 --namespace logging

# 6. Install fluentd
# Update Elastic creds in fluentd.yaml
kubectl apply -f fluentd.yaml


---
# // Uninstall kibana
helm uninstall kibana --namespace logging

# // Uninstall elasticsearch
helm uninstall elasticsearch --namespace logging

# // Uninstall fluentd
kubectl delete -f fluentd.yaml




