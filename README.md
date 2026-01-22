 #### 1. crea carpeta Theory para guardar las tasks
 #### 2. crea carpeta Practice para guardar la actividad.
 #### 3. desarrolle el ejercicio
    #### instale 

 ```
 npm install express prom-client winston
 ```
 ``` # Instalar herramientas de monitoreo 
 npm install winston prom-client pm2
 ```
 ``` # Crear directorios de monitoreo
 mkdir -p monitoring/grafana/provisioning/datasources
 mkdir -p monitoring/grafana/provisioning/dashboards
 mkdir -p logs
 ```
 ``` # Configurar PM2
 npm install -g pm2
 pm2 startup
 pm2 save
 ```

#### Detiene y elimina contenedores en conflicto
```
docker-compose -f docker-compose.monitoring.yml down
```

#### Elimina imagen actual
```
docker rmi docker-compose-monitoring_app:latest
```

#### Levanta el proyecto con el siguiente comando
```
docker-compose -f docker-compose.monitoring.yml up -d --build
```

#### comprueba en la terminal que el PM2 esta funcionando realmente dentro del contenedor
```
docker exec -it docker-compose-monitoring_app_1 pm2 list
```