export Node_ip=$1

export elastic_namespace=$2
export zabbix_namespace=$3
export grafana_namespace=$4

chmod +x elastic-helm/efk.sh
chmod +x zabbix/zabbix-helm/zabbix.sh
chmod +x grafana/helm-grafana/grafana.sh

cp ./grafana/helm-grafana/dashboard.json $Home/dashboard.json

./elastic-helm/efk.sh $elastic_namespace $Node_ip
./zabbix/zabbix-helm/zabbix.sh $zabbix_namespace $Node_ip
./grafana/helm-grafana/grafana.sh $grafana_namespace $Node_ip


echo "
Grafana: http://$Node_ip:3000/
Zabbix: http://$Node_ip/
Kibana: http://$Node_ip:5601/
Fluent-bit: http://$Node_ip:2020/
ElasticSearch: http://$Node_ip:9200/
# If you are not using self-signed certificat you can change to https.
"

# All installations of grafana are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
#watch kubectl get all --namespace=$elastic_namespace
#watch kubectl get all --namespace=$grafana_namespace
#watch kubectl get all --namespace=$zabbix_namespace


#To uninstall 

# helm uninstall elasticsearch -n $elastic_namespace
# kubectl delete ns $elastic_namespace
# kubectl delete ns $zabbix_namespace
# kubectl delete ns $grafana_namespace
# kubectl delete pv zabbix-pv 
