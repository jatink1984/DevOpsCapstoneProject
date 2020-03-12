
#! /bin/bash

CURRENT=$(ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl get service bluegreenlb -o jsonpath='{.spec.selector.app}')
if [ $CURRENT == "blue" ]
then
 echo "blue is live, create new green deployment."
 ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl apply -f green-deployment.yml
 READY=$(ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl get deploy green -o json | ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
 while [[ "$READY" != "True" ]]; do
   READY=$(ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl get deploy green -o json | ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
   sleep 2
 done
 ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl patch svc bluegreenlb -p "{\"spec\":{\"selector\": {\"app\": \"green\"}}}"
 echo "Green is Live."
 ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl delete deployment blue
else echo "green is live, create new blue deployment."
        ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl apply -f blue-deployment.yml
        READY=$(ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl get deploy blue -o json | ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
        while [[ "$READY" != "True" ]]; do
          READY=$(ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl get deploy blue -o json | ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
          sleep 2
        done
 ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl patch svc bluegreenlb -p "{\"spec\":{\"selector\": {\"app\": \"blue\"}}}"
 echo "Blue is Live."
 ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl delete deployment green
fi 
