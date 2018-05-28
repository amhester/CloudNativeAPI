SHELL := /bin/bash

.PHONY: run build build-alpine build-docker push-gcr deploy

all:

auth:
	gcloud auth application-default login

create-project:
	gcloud projects create sample-gke-api --name="Sample GKE API"
	gcloud config set project sample-gke-api
	gcloud auth application-default login
	gcloud services enable endpoints.googleapis.com

create-cluster:
	gcloud container clusters create sample-gke-api-cluster --zone us-central1-a --machine-type g1-small --num-nodes 1
	gcloud config set container/cluster sample-gke-api-cluster
	gcloud container clusters get-credentials sample-gke-api-cluster

run:
	go build -o ./bin/api && ./bin/api

build:
	go build -o ./bin/api

build-alpine:
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./bin/api

build-docker:
	docker build -f Dockerfile -t gcr.io/sample-google-project/api:latest .

push-gcr:
	gcloud docker -- push gcr.io/sample-google-project/api:latest

deploy-api:
	kubectl apply -f ./api-deployment.yaml && kubectl apply -f ./api-svc.yaml

deploy-ingress:
	kubectl apply -f ./ingress.yaml