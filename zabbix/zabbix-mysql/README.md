# zabbix-kubernetes

```
export IP_node0=10.242.148.48
export IP_node1=10.242.148.149

export WEB_HOST_IP=$IP_node0
export ZX_SERVER_HOST_IP=$IP_node0
export ZABBIX_HOST_PORT=10050
export DB_HOST_IP=$IP_node0
export DB_HOST_PORT=3306
export PROXY_HOST_IP=$IP_node1
sed -i -e "s/<Specify WEB external IP here>/${WEB_HOST_IP}/" ./*.yaml
sed -i -e "s/<Specify PROXY external IP here>/${PROXY_HOST_IP}/" ./*.yaml
sed -i -e "s/<Specify ZX external IP here>/${ZX_SERVER_HOST_IP}/" ./*.yaml
sed -i -e "s/<Specify ZX external PORT here>/${ZABBIX_HOST_PORT}/" ./*.yaml
sed -i -e "s/<Specify DB external IP here>/${DB_HOST_IP}/" ./*.yaml
sed -i -e "s/<Specify DB external PORT here>/${DB_HOST_PORT}/" ./*.yaml
sed -i -e "s/<Specify external IP here>/${WEB_HOST_IP}/" ./*.yaml

```

`kubectl apply -f zabbix-kubernetes/zabbix-mysql/1/`

## To fix CrashLoopBackOff of zabbix-server

kubectl -n zabbix delete po $(kubectl -n zabbix get po | grep mysql-server | awk '{print $1}')
kubectl -n zabbix delete po $(kubectl -n zabbix get po | grep zabbix-server | awk '{print $1}')

kubectl -n zabbix logs po/$(kubectl -n zabbix get po | grep zabbix-server | awk '{print $1}' | head -n 1) -c zabbix-server
kubectl -n zabbix  describe po/$(kubectl -n zabbix get po | grep zabbix-server | awk '{print $1}' | head -n 1) 
kubectl -n zabbix  logs po/$(kubectl -n zabbix get po | grep zabbix-server | awk '{print $1}' | tail -n 1) -c zabbix-server
