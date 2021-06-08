#*** assure that you have a working kubernetes cluster and any helm version are well installed before executing this script ***

# --- Deploy Grafana ---

# Add the chart repository for the Helm chart to be installed.
helm repo add grafana https://grafana.github.io/helm-charts


# Create namespace
export namespace=$1 || grafana
kubectl create namespace $namespace

# set Node IP address to open external port in one of your cluster node (if loadbalancer not supported).
export hostIP=$2 || 10.242.148.48

# Change Chart values file
echo "
replicas: 1
image:
  tag: 7.4.5 
service:
  type: NodePort
  port: 3000
  externalIPs: 
  - $hostIP
grafana.ini:
  security:
    allow_embedding: true
  auth.anonymous:
    enabled: true
plugins:
- alexanderzobnin-zabbix-app
# extraVolumeMounts:
# - name: plugins
#   mountPath: /var/lib/grafana/plugins
#   subPath: configs/grafana/plugins
#   existingClaim: grafana
#   readOnly: false
# - name: dashboards
#   mountPath: /var/lib/grafana/dashboards
#   hostPath: /grafana/dashboards
#   readOnly: false
# persistence:
#   enabled: true
#   type: pvc
#   size: 10Gi
#   existingClaim: grafana
" > $Home/grafana_values.yaml

# To install the chart with the release name grafana:
helm install grafana grafana/grafana \
-n $namespace \
-f $Home/grafana_values.yaml

# Create persistance volume for grafana
# cat <<EOF | kubectl -n $namespace create -f - 
# kind: PersistentVolume
# apiVersion: v1
# metadata:
#   name: grafana
#   labels:
#     type: local
#   namespace: $namespace
# spec:
#   capacity:
#     storage: 10Gi
#   accessModes:
#     - ReadWriteOnce
#   hostPath:
#     path: "/grafana"
# ---
# apiVersion: v1
# kind: PersistentVolumeClaim
# metadata:
#   name: grafana
#   namespace: $namespace
# spec:
#   accessModes:
#     - ReadWriteMany
#   resources:
#     requests:
#       storage: 10Gi
#   volumeName: grafana
# EOF

clear
# Get 'admin' user password by running
echo "Grafana admin password: "
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# optional 
# To Get the Grafana URL to visit by running these commands in the same shell:
# export NODE_PORT=$(kubectl get --namespace grafana -o jsonpath="{.spec.ports[0].nodePort}" services grafana)
# export NODE_IP=$(kubectl get nodes --namespace grafana -o jsonpath="{.items[0].status.addresses[0].address}")
# echo http://$NODE_IP:$NODE_PORT

# All installations of grafana are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
#watch kubectl get all --namespace=$namespace

# To delete :
# helm delete grafana -n grafana