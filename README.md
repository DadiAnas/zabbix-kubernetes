# Deploy Zabbix, Grafana and EFK stack on Kubernetes

## Requirements

In order to install all the charts: Zabbix, grafana and EFK stack (ElasticSearch/Fluent-bit/Kibana) on kubernetes, you must have a well configured kubernetes cluster.

In my case I am using a Kubernetes cluster that runing on Virtual Machines with VMware Photon Os in a VMware ESXI Server. If you need to install configure your own cluster using VMs with photon OS, you should have a look to git repo directory `kubeadm` you must find two scripts to install kubeadm on master node and other for workers.

The second thins that you need is helm, the package manager for kubernetes, installed on the master node, take a look in [helm website](https://helm.sh/docs/intro/install/) for that.

To sum it up:

- Kubernetes Cluster
- Helm package manager

## Deployment

If your environement match well the requirements, you can now easily deploy all the charts.

### Method 1

You just need to change Node_ip variable to match your configuration (IP address of one of your cluster node), than paste it in your master node command line:

    export Node_ip=10.242.148.48

    git clone https://github.com/DadiAnas/zabbix-kubernetes
    cd zabbix*kubernetes*
    chmod +x ./install-Zabbix-Efk-Grafana.sh

    export elastic_namespace=elastic
    export zabbix_namespace=zabbix
    export grafana_namespace=grafana

    ./install-Zabbix-Efk-Grafana.sh \
    $Node_ip \
    $elastic_namespace \
    $zabbix_namespace \
    $grafana_namespace

After the installation, links to get access to the deployments will be printed.

### Method 2

One line installation command :), change the ip with the ip of one of your cluster nodes, then you can change namespaces if you want, it's optional.

## Debug

All installations are either still initializing or fully available. To inspect the status of these deployments run this watchs:

    watch kubectl get all --namespace=$elastic_namespace
    watch kubectl get all --namespace=$grafana_namespace
    watch kubectl get all --namespace=$zabbix_namespace

## Delete

Uninstalling all charts may be result by deleting helm charts or by deleting namespaces:

    helm uninstall elasticsearch -n $elastic_namespace
    helm uninstall kibana -n $elastic_namespace
    helm uninstall fluent-bit -n $elastic_namespace
    helm uninstall zabbix -n $zabbix_namespace
    helm uninstall grafana -n $grafana_namespace

OR:

    kubectl delete ns $elastic_namespace
    kubectl delete ns $zabbix_namespace
    kubectl delete ns $grafana_namespace

To delete zabbix postgresql persistance volume:

    kubectl delete pv zabbix-pv

Enjoy.
