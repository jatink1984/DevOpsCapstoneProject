### AWS EKS - Blue/Green deployment

![img-1](images/1-Diagram_EKS_blue_green_deployment.png)

## Overview
This project uses cloudformation to build the aws infrastructure. AWS EKS is used to create a Kubernetes cluster. Once the infrastruture is ready, a sample application is deployed to Kubernetes cluster. Application is made available to public using loadbalancer service. The project is configured to use blue/green deployment methodology.

Technologies/Concepts used:
1. AWS
2. Docker
3. Kubernetes - AWS EKS 
4. Jenkis

## &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; Project Setup

## Create Infrastructure
Infrastructure is deployed using create.sh script with following parameters &nbsp;
``` sh ./create.sh DevOpsCapstoneProject eks_cloud_infrastrucure.yml eks_cloud_infrastrucure.json ```

## Setup Jenkins pipline 
1. Perform lint operation on html files in the application code 
2. Perform lint operation of Dockerfiles
3. Create Docker images for blue/green deployment in dockerhub
4. Deploy application docker image to kubernetes cluster, blue deployment becomes live

```Any new code commit triggers the Jenkins pipeline. Step "Deploy application to Kubernetes" determines the current live version. It creates a new deployment(blue/green depending on current live version), patches load balancer to point to newly created deployment. The step then waits for the new deployment to becomes available and then deletes the older deployment```

