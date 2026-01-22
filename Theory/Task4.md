Task 4: Rollback y Recovery (4 minutos)
Estrategias para recuperarse de despliegues fallidos.

# Rollback automático con health checks
#!/bin/bash

# Función de rollback
rollback() {
  echo "🚨 Iniciando rollback..."

  # Cambiar tráfico de vuelta a versión anterior
  kubectl set image deployment/my-app app=my-app:v1

  # Esperar a que se despliegue
  kubectl rollout status deployment/my-app

  echo "✅ Rollback completado"
  exit 1
}

# Health check después de deployment
echo "⏳ Verificando health después de deployment..."

# Esperar a que los pods estén ready
kubectl wait --for=condition=available --timeout=300s deployment/my-app

# Verificar endpoint de health
if curl -f http://my-app.com/health; then
  echo "✅ Deployment exitoso"
else
  echo "❌ Health check falló"
  rollback
fi
# Kubernetes deployment con rollback automático
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    spec:
      containers:
      - name: app
        image: my-app:latest
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3