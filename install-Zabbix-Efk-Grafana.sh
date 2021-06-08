export Node_ip=$1 || 10.242.148.48

export elastic_namespace=$2 || elastic
export zabbix_namespace=$3 || zabbix
export grafana_namespace=$4 || grafana

chmod +x elastic-helm/install.sh
chmod +x zabbix/zabbix-helm/install.sh
chmod +x grafana/helm-grafana/install.sh

./elastic-helm/install.sh $elastic_namespace
./zabbix/zabbix-helm/install.sh $zabbix_namespace $Node_ip
./grafana/helm-grafana/install.sh $grafana_namespace $Node_ip

echo "use this commands one by one"
echo "kubectl edit -n $elastic_namespace svc/kibana-kibana" 
echo "kubectl edit -n $zabbix_namespace svc/zabbix-web" 
echo "and add to spec: 
  externalIPs:
   - $Node_ip
"

echo "After changing it you can have acces to :
Grafana: http://$Node_ip:3000/
Zabbix: http://$Node_ip/
Elastic: http://$Node_ip:5601/
# If you are not using self-signed certificat you can change to https.
"

# All installations of grafana are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
#watch kubectl get all --namespace=$elastic_namespace
# Change namespace to see others.

#To uninstall 
# kubectl delete ns $elastic_namespace
# kubectl delete ns $zabbix_namespace
# kubectl delete ns $grafana_namespace
# kubectl delete pv pv-zabbix 