# zabbix-kubernetes

cd postgres or mysql folder
`sed -i -e 's/<Specify external IP here>/10.242.148.80/' ./*-svc.yaml`
`sed -i -e 's/<Specify DB external IP here>/10.242.148.80/' ./*.yaml`

`kubectl apply -f zabbix-kubernetes/`
