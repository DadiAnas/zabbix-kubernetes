#*** assure that you have a working kubernetes cluster and any helm version are well installed before executing this script ***

# Create namespace
export namespace=$1
kubectl create namespace $namespace

# Host ip to give access to external within it
export hostIP=$2

# --- Deploy ElasticSearch ---
#'''
# Elasticsearch is a RESTful search engine based on the Lucene library. 
# It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. 
# Elasticsearch is open source and developed in Java.
# ''' 

# Add the chart repository for the Helm chart to be installed.
helm repo add elastic https://helm.elastic.co

# Change Chart values file
echo "
# Permit co-located instances for solitary minikube virtual machines.
antiAffinity: "soft"

# Shrink default JVM heap.
esJavaOpts: "-Xmx128m -Xms128m"

# Allocate smaller chunks of memory per pod.
resources:
  requests:
    cpu: "100m"
    memory: "512M"
  limits:
    cpu: "1000m"
    memory: "512M"

persistence:
  enabled: false
" > $Home/elastic-values.yaml

# Deploy the public Helm chart for ElasticSearch.
helm install elasticsearch elastic/elasticsearch \
--namespace=$namespace \
-f $Home/elastic-values.yaml 
#--version=7.13.0 

# expose ElasticSearch API port to extern
kubectl expose svc/elasticsearch-master -n $namespace --type=NodePort --name=elastic-api-external --external-ip=$hostIP --port=9200 --target-port=9200


# --- Deploy Fluent Bit ---
# '''
# Fluent Bit is an open source specialized data collector.
# It provides built-in metrics and general purpose output interfaces for 
# centralized collectors such as Fluentd. Create the configuration for Fluent Bit.
# 
# Install Fluent Bit and pass the ElasticSearch service endpoint as a chart parameter.
# This chart will install a DaemonSet that will start a Fluent Bit pod on each node. 
# With this, each Fluent Bit service will collect the logs from each node and stream it to ElasticSearch.
# '''

# Add the chart repository for the Helm chart to be installed.
helm repo add fluent https://fluent.github.io/helm-charts
# Install the chart.
helm install fluent-bit fluent/fluent-bit \
  --namespace=$namespace
 # --version 0.15.13 

# expose fluent-bit to external
kubectl expose svc/fluent-bit -n $namespace --type=NodePort --name=fluent-bit-external --external-ip=$hostIP --port=2020 --target-port=2020


# --- Deploy Kibana ---

# '''
# Kibana is a free and open user interface that lets you visualize your Elasticsearch
# data and navigate the Elastic Stack. Do anything from tracking query load 
# to understanding the way requests flow through your apps.
# '''

# Deploy Kibana. The service will be on a NodePort at 31000.
helm install kibana elastic/kibana \
  --namespace=$namespace \
  --set healthCheckPath="/api/status" \
  --set replicas=2
  #--version=7.13.0 
### Security caution.  
### This NodePort exposes the logging to the outside world intentionally for demonstration purposes.
### However, for production Kubernetes clusters never expose the Kibana dashboard service to the world without any authentication.

# expose port to extern
kubectl expose svc/kibana-kibana -n $namespace --type=NodePort --name=kibana-external --external-ip=$hostIP --port=5601 --target-port=5601


# --- Verify Running Stack ---
# All three installations of ElasticSearch, Fluent Bit, and Kibana are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
#watch kubectl get deployments,pods,services --namespace=$namespace

# To delete chart you can use:
# helm delete kibana -n $namespace
# helm delete fluent-bit -n $namespace
# helm delete elasticsearch -n $namespace

# Or just delete namespace if it does not contain any other deployments