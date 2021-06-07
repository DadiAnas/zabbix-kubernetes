export hostIP=10.242.148.48
# Create namespace in Kubernetes cluster.
export namespace=monitoring
kubectl create namespace $namespace

# Add Helm repo
helm repo add cetic https://cetic.github.io/helm-charts

# Update the list helm chart available for installation
helm repo update

# Export default values of chart helm-zabbix to file zabbix_values.yaml
#helm show values cetic/zabbix > zabbix_values.yaml

# Change the values according to the environment in the file zabbix_values.yaml.

# Install the Zabbix helm chart with a release name : zabbix-release
helm install zabbix cetic/zabbix --dependency-update \
-n $namespace \
--set zabbixServer.hostIP=$hostIP \
--set zabbixServer.image.tag="ubuntu-5.4.0" \
--set zabbixagent.image.tag="ubuntu-5.4.0" \
--set zabbixproxy.image.tag="ubuntu-5.4.0" \
--set zabbixweb.image.tag="ubuntu-5.4.0"
#-f zabbix_values.yaml 


# Create persistance volume for postgresql
cat <<EOF | kubectl -n $namespace create -f - 
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-zabbix
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/zabbix_data"
EOF


# --- Verify Running Stack ---
# All installations of Zabbix-server, Zabbix-web, Zabbix-proxy, PostgreSQL and Zabbix-web are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
watch kubectl get deployments,pods,services --namespace=$namespace

# kubectl edit svc/zabbix-web -n $namespace
# kubectl edit svc/zabbix-server -n $namespace
#  externalIPs:
#  - 10.242.148.48