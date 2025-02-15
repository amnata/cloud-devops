```sh
kubectl get nodes -o wide

kubectl create namespace nginx-namespace
kubectl create deployment nginx --image=nginx -n nginx-namespace
kubectl get deployment nginx -n nginx-namespace
kubectl describe deployment nginx -n nginx-namespace
kubectl scale deployment nginx --replicas=3 -n nginx-namespace
kubectl get deployment nginx -n nginx-namespace

kubectl expose deployment nginx --type=NodePort --port=80 --name=nginx-service -n nginx-namespace
kubectl get service nginx-service -n nginx-namespace
kubectl describe service nginx-service -n nginx-namespace


## Export to json
kubectl get pods -o json > pods.json
## Query json
kubectl get pods -o json | jq '.items[].metadata.name'
cat  pods.json | jq '.items[].metadata.name' pods.json

## Export to yaml
kubectl get pods -o yaml > pods.yaml


## JsonPath
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
kubectl get pods -o jsonpath='{.items[*].spec.nodeName}'
kubectl get service nginx-service -o jsonpath='{.spec.ports[0].nodePort}'


kubectl create secret generic my-secret --from-literal=username=user --from-literal=password=password
kubectl get secret my-secret -o yaml
kubectl delete secret my-secret

kubectl create configmap my-configmap --from-literal=key1=value1 --from-literal=key2=value2
kubectl get configmap my-configmap -o yaml
kubectl delete configmap my-configmap

kubectl create volume pvc my-pvc --storage-class=standard --capacity=1Gi
kubectl get pvc my-pvc
kubectl delete pvc my-pvc

kubectl create volume pv my-pv --capacity=1Gi --access-modes=ReadWriteOnce --hostPath=path/to/host/directory
kubectl get pv my-pv
kubectl delete pv my-pv

kubectl create volume persistentvolumeclaim my-pvc --storage-class=standard --capacity=1Gi
kubectl get persistentvolumeclaim my-pvc
kubectl delete persistentvolumeclaim my-pvc

kubectl create volume persistentvolume my-pv --capacity=1Gi --access-modes=ReadWriteOnce --hostPath=path/to/host/directory
kubectl get persistentvolume my-pv
kubectl delete persistentvolume my-pv

```