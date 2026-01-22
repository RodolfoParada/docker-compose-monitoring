Task 1: Estrategias de Despliegue (8 minutos)
Métodos para desplegar aplicaciones de forma segura.

# Blue-Green Deployment
# Dos ambientes idénticos: Blue (producción) y Green (staging)
# Ventajas: Zero-downtime, rollback instantáneo

# Implementación básica:
# 1. Desplegar en Green
# 2. Probar Green exhaustivamente
# 3. Cambiar tráfico a Green (ahora es producción)
# 4. Mantener Blue como backup
# 5. Próximo despliegue: Blue se convierte en staging
# Canary Deployment
# Liberar nueva versión gradualmente
# Ventajas: Reducir riesgo, testing en producción real

# Estrategia:
# 1. 5% del tráfico -> Nueva versión
# 2. Monitorear métricas (errores, performance)
# 3. Si OK: aumentar a 25%, luego 50%, 100%
# 4. Si problemas: rollback inmediato
# GitHub Actions para Blue-Green
name: Blue-Green Deployment

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Deploy to Green environment
      run: |
        echo "Deploying to green environment..."
        # Lógica de deployment a green

    - name: Health check
      run: |
        curl -f https://green.example.com/health || exit 1

    - name: Switch traffic to Green
      run: |
        # Actualizar load balancer
        echo "Switching traffic to green..."

    - name: Monitor and rollback if needed
      run: |
        # Monitorear por 5 minutos
        sleep 300
        # Si hay errores > threshold, rollback
