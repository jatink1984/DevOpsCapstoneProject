#! /bin/bash

if [ -f /home/ec2-user/*.yml ]; then
        rm *.yml
fi
if [ -f /home/ec2-user/createDeployment.sh ]; then
        rm createDeployment.sh
fi
if [ -f /home/ec2-user/copyDeploymentFiles.sh ]; then
        rm copyDeploymentFiles.sh
fi
scp -o StrictHostKeyChecking=no createDeployment.sh copyDeploymentFiles.sh blue-green/blue-green-loadbalancer.yml blue-green/blue/blue-deployment.yml blue-green/green/green-deployment.yml ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com:/home/ec2-user