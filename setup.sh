#!/bin/bash

minikube delete
minikube start --cpus=4 --memory=3.2G --kubernetes-version=1.25.3 ; minikube ssh "sudo mkdir -p /mnt/disk1/data" 
minikube tunnel &

sleep 16

kubectl create ns minio
kubectl apply -f minio.yaml
kubectl apply -f minio-svc.yaml 

sleep 16

mc alias set adminloki http://localhost:9000/ minioadmin minioadmin
mc admin user add adminloki loki lokiloki
mc  admin policy set adminloki readwrite user=loki
mc alias set loki http://localhost:9000/ loki lokiloki
mc mb loki/loki 

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install --values loki-values.yaml loki grafana/loki
kubectl apply -f loki-svc.yaml 





