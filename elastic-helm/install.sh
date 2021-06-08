#*** assure that you have a working kubernetes cluster and any helm version are well installed before executing this script ***

# Create namespace
export namespace=$1 || elastic
kubectl create namespace $namespace

# --- Deploy ElasticSearch ---
#'''
# Elasticsearch is a RESTful search engine based on the Lucene library. 
# It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. 
# Elasticsearch is open source and developed in Java.
# ''' 

# Add the chart repository for the Helm chart to be installed.
helm repo add elastic https://helm.elastic.co
# Deploy the public Helm chart for ElasticSearch.
helm install elasticsearch elastic/elasticsearch \
--namespace=$namespace \
-f elastic-values.yaml 
#--version=7.13.0 

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

# --- Deploy Kibana ---

# '''
# Kibana is a free and open user interface that lets you visualize your Elasticsearch
# data and navigate the Elastic Stack. Do anything from tracking query load 
# to understanding the way requests flow through your apps.
# '''

# Deploy Kibana. The service will be on a NodePort at 31000.
helm install kibana elastic/kibana \
  --namespace=$namespace \
  --set service.type=NodePort \
  --set service.nodePort=31000 
  #--version=7.13.0 
### Security caution.  
### This NodePort exposes the logging to the outside world intentionally for demonstration purposes.
### However, for production Kubernetes clusters never expose the Kibana dashboard service to the world without any authentication.


# --- Verify Running Stack ---
# All three installations of ElasticSearch, Fluent Bit, and Kibana are either still initializing or fully available.
# To inspect the status of these deployments run this watch.
watch kubectl get deployments,pods,services --namespace=$namespace

# To delete chart you can use:
# helm delete kibana -n $namespace
# helm delete fluent-bit -n $namespace
# helm delete elasticsearch -n $namespace

# Or just delete namespace if it does not contain any other deployments