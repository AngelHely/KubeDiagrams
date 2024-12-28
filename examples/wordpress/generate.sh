#! /bin/sh

BIN=../../bin

# Generate the Kubernetes architecture diagram for WordPress manifests.
$BIN/kube-diagrams -o wordpress *.yaml

# Deploy the WordPress application.
kubectl apply -f mysql-pass.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f wordpress-deployment.yaml

# Wait a few minutes for the WordPress application to be deployed.
sleep 10

# Get all Kubernetes resources in the `default` namespace.
kubectl get all,sa,cm,secret,pvc,pv,sc -o=yaml > namespace_default.yml

# Generate a Kubernetes architecture diagram for the `default` namespace.
$BIN/kube-diagrams namespace_default.yml

# Delete the WordPress application.
kubectl delete -f wordpress-deployment.yaml
kubectl delete -f mysql-deployment.yaml
kubectl delete -f mysql-pass.yaml
