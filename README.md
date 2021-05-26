# zabbix-kubernetes

```
export WEB_HOST_IP=10.242.148.48

export ZX_SERVER_HOST_IP=10.242.148.48
export ZABBIX_HOST_PORT=10050

export DB_HOST_IP=10.242.148.48
export DB_HOST_PORT=3306

export PROXY_HOST_IP=10.242.148.149

sed -i -e "s/<Specify WEB external IP here>/${WEB_HOST_IP}/" ./*.yaml

sed -i -e "s/<Specify PROXY external IP here>/${PROXY_HOST_IP}/" ./*.yaml

sed -i -e "s/<Specify ZX external IP here>/${ZX_SERVER_HOST_IP}/" ./*.yaml
sed -i -e "s/<Specify ZX external PORT here>/${ZABBIX_HOST_PORT}/" ./*.yaml

sed -i -e "s/<Specify DB external IP here>/${DB_HOST_IP}/" ./*.yaml
sed -i -e "s/<Specify DB external PORT here>/${DB_HOST_PORT}/" ./*.yaml

sed -i -e "s/<Specify external IP here>/${WEB_HOST_IP}/" ./*.yaml

```

`kubectl apply -f zabbix-kubernetes/`

kubectl -n zabbix delete po $(kubectl -n zabbix get po | grep mysql-server | awk '{print $1}')
