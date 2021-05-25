# zabbix-kubernetes

cd postgres or mysql folder
`sed -i -e 's/<Specify external IP here>/10.242.148.48/' ./*.yaml`
`sed -i -e 's/<Specify DB external IP here>/10.242.148.48/' ./*.yaml` or `sed -i -e 's/<Specify DB external IP here>/mysql-server/' ./*.yaml`

```
sed -i -e 's/<Specify external IP here>/10.242.148.48/' ./*.yaml
sed -i -e 's/<Specify ZX external IP here>/10.242.148.48/' ./*.yaml
sed -i -e 's/<Specify DB external IP here>/10.242.148.48/' ./*.yaml
sed -i -e 's/<Specify DB external PORT here>/3306/' ./*.yaml
sed -i -e 's/<Specify ZX external PORT here>/10050/' ./*.yaml
```

`kubectl apply -f zabbix-kubernetes/`
