# Zabbix, Grafana and EFK (ElasticSearch/Fluent-bit/Kibana) on Kubernetes

## Requirements

In order to install all the charts: Zabbix, grafana and EFK stack on kubernetes, you must have a well configured kubernetes cluster.

In my case I am using a Kubernetes cluster that runing on Virtual Machines with VMware Photon Os in a VMware ESXI Server. If you need to install configure your own cluster using VMs with photon OS, you should have a look to git repo directory `kubeadm` you must find two scripts to install kubeadm on master node and other for workers.

The second thins that you need is helm, the package manager for kubernetes, installed on the master node, take a look in [helm website](https://helm.sh/docs/intro/install/) for that.

To sum it up:

- Kubernetes Cluster
- Helm package manager

# Steps

If your environement match well the requirements, you can now easily install the charts.

First step is to clone the repository, and go to the directory to make script executable, just copy paste the script below:

    git clone https://github.com/DadiAnas/zabbix-kubernetes
    cd zabbix*kubernetes*
    chmod +x ./install-Zabbix-Efk-Grafana.sh

after that, in the script below change variables than paste it in your master node command line:

    # The IP address of one of your cluster node,
    # to give access to external
    export Node_ip=10.242.148.48
    export elastic_namespace=elastic
    export zabbix_namespace=zabbix
    export grafana_namespace=grafana

    ./install-Zabbix-Efk-Grafana.sh \
    $Node_ip \
    $elastic_namespace \
    $zabbix_namespace \
    $grafana_namespace

Than you have to follow some steps to give access to external to zabbix and elastic, if you are not using local cluster.
The step will be printed, otherwise you must add

    externalIPs:
    - <Node_ip >

in spec in services to open external ports.

After installation links to access the deployments will be printed.

Enjoy your life.
