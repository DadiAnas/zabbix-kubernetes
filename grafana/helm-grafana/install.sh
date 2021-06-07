#*** assure that you have a working kubernetes cluster and any helm version are well installed before executing this script ***

# set Node IP address to open external port in one of your cluster node (if loadbalancer not supported).
export hostIP={10.242.148.48}
# Create namespace
export namespace=grafana
kubectl create namespace $namespace

# --- Deploy Grafana ---

# Add the chart repository for the Helm chart to be installed.
helm repo add grafana https://grafana.github.io/helm-charts

echo '
grafana.ini:
  security:
    allow_embedding: true
  auth.anonymous:
    enabled: true
' > grafana_values.yaml

# To install the chart with the release name grafana:
helm install grafana grafana/grafana \
-n $namespace \
--set replicas=1 \
--set image.tag=7.4.5 \
--set service.type=NodePort \
--set service.port=3000 \
--set service.externalIPs=$hostIP \
--set grafana.ini={allow_embedding=false} \
-f grafana_values.yaml

# Get 'admin' user password by running
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# optional 
# To Get the Grafana URL to visit by running these commands in the same shell:
export NODE_PORT=$(kubectl get --namespace grafana -o jsonpath="{.spec.ports[0].nodePort}" services grafana)
export NODE_IP=$(kubectl get nodes --namespace grafana -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT

# All installations of grafana are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
watch kubectl get all --namespace=$namespace