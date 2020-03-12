#! /bin/bash
PATH=$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin
export PATH

CURRENT=$(kubectl get service bluegreenlb -o jsonpath='{.spec.selector.app}')
if [ $CURRENT == "blue" ]
then
 echo "blue is live, create new green deployment."
 kubectl apply -f green-deployment.yml
# kubectl apply -f blue-green/green/green-deployment.yml
 READY=$(kubectl get deploy green -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
 while [[ "$READY" != "True" ]]; do
   READY=$(kubectl get deploy green -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
   sleep 2
 done
 kubectl patch svc bluegreenlb -p "{\"spec\":{\"selector\": {\"app\": \"green\"}}}"
 echo "Green is Live."
 kubectl delete deployment blue
else echo "green is live, create new blue deployment."
#        kubectl apply -f blue-green/blue/blue-deployment.yml
        kubectl apply -f blue-deployment.yml
        READY=$(kubectl get deploy blue -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
        while [[ "$READY" != "True" ]]; do
          READY=$(kubectl get deploy blue -o json | jq '.status.conditions[] | select(.reason == "MinimumReplicasAvailable") | .status' | tr -d '"')
          sleep 2
        done
 kubectl patch svc bluegreenlb -p "{\"spec\":{\"selector\": {\"app\": \"blue\"}}}"
 echo "Blue is Live."
 kubectl delete deployment green
fi