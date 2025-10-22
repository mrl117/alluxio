# 1. Configurar kubectl para conectarse al cluster EKS
aws eks update-kubeconfig --region us-east-1 --name tach-dev-eks-cluster-001

kubectl get nodes

# 1. Asegurarse de que el namespace existe
kubectl create namespace alluxio-system --dry-run=client -o yaml | kubectl apply -f -

# 2. Aplicar RBAC primero
kubectl apply -f alluxio-rbac.yaml

# 3. Aplicar ConfigMap
kubectl apply -f alluxio-config.yaml

# 4. Aplicar Service
kubectl apply -f alluxio-service.yaml
kubectl apply -f alluxio-worker-service.yaml

# 5. Aplicar Secret (si no existe)
kubectl create secret generic alluxio-s3-credentials \
  --namespace alluxio-system \
  --from-literal=accessKey="my-access-key" \
  --from-literal=secretKey=wl0ci3/wzWzq6XNYMVGGNxam1jMamWl********* \
  --dry-run=client -o yaml | kubectl apply -f -

# 6. Aplicar Master y Worker
kubectl apply -f alluxio-master.yaml
kubectl apply -f alluxio-worker.yaml

# 7. Esperar a que los pods estén listos
kubectl wait --for=condition=ready pod -l app=alluxio-master -n alluxio-system --timeout=30s
kubectl wait --for=condition=ready pod -l app=alluxio-worker -n alluxio-system --timeout=30s


# 6. Verificar que todo funcione
## Verificar todos los recursos
kubectl get all -n alluxio-system

## Verificar pods
kubectl get pods -n alluxio-system

## Verificar servicios
kubectl get svc -n alluxio-system

## Verificar logs del master
kubectl logs -f deployment/alluxio-master -n alluxio-system

## Probar conectividad
kubectl exec -it deployment/alluxio-master -n alluxio-system -- alluxio fsadmin report


# ejecutar la prueba final
## Eliminar el job anterior si existe
kubectl delete job alluxio-s3-test-final -n alluxio-system --ignore-not-found=true

## Aplicar el job de prueba
kubectl apply -f test-alluxio-s3-final.yaml

## Verificar el job
kubectl get jobs -n alluxio-system

## Ver logs del job
kubectl logs job/alluxio-s3-test-final -n alluxio-system -f

# Troubleshooting adicional
## Verificar ServiceAccount
kubectl get serviceaccount -n alluxio-system

## Verificar eventos recientes
kubectl get events -n alluxio-system --sort-by=.metadata.creationTimestamp

## Verificar descripción de pods fallidos
kubectl describe pod -l app=alluxio-master -n alluxio-system

## Verificar descripción del deployment
kubectl describe deployment alluxio-master -n alluxio-system

## Verificar descripción del daemonset
kubectl describe daemonset alluxio-worker -n alluxio-system

## Verificar DNS
kubectl run alluxio-diag --image=busybox --rm -it --restart=Never -- sh -c "
echo '=== DNS Check ==='
nslookup alluxio-master.alluxio-system.svc.cluster.local
echo '=== Network Check ==='
nc -zv alluxio-master.alluxio-system.svc.cluster.local 19998
nc -zv alluxio-master.alluxio-system.svc.cluster.local 19999
echo '=== Service Endpoints ==='
nslookup -type=SRV alluxio-master.alluxio-system.svc.cluster.local
"


## Probar operaciones S3 desde el master
## Probar S3 desde el master
kubectl exec -it deployment/alluxio-master -n alluxio-system -- bash -c "
echo '=== Verificando variables de entorno ==='
echo 'AWS_ACCESS_KEY_ID:' \$AWS_ACCESS_KEY_ID
echo 'AWS_SECRET_ACCESS_KEY:' \$AWS_SECRET_ACCESS_KEY
echo '=== Probando S3 ==='
alluxio fs ls /
"

## Verificar DNS desde dentro del pod del master
kubectl exec -it deployment/alluxio-master -n alluxio-system -- bash

## Dentro del pod:
cat /etc/resolv.conf
nslookup alluxio-master.alluxio-system.svc.cluster.local
ping alluxio-master.alluxio-system.svc.cluster.local



Con lo que se cuenta
✅ Alluxio Cluster funcionando
✅ Credenciales S3 configuradas correctamente
✅ Comunicación Master-Workers estable
✅ Operaciones básicas de S3 funcionando

El problema restante es solo la comunicación entre workers para caching de datos, que podemos resolver con la configuración de servicio headless para workers.