export Node_ip=$1
export elastic_namespace=$2
export zabbix_namespace=$3
export grafana_namespace=$4

git clone https://github.com/DadiAnas/zabbix-kubernetes
cd zabbix*kubernetes*
chmod +x ./install-Zabbix-Efk-Grafana.sh
./install-Zabbix-Efk-Grafana.sh \
$Node_ip \
$elastic_namespace \
$zabbix_namespace \
$grafana_namespace