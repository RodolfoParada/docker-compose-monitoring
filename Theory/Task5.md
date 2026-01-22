Task 5: Optimización de Performance (4 minutos)
Mejorar rendimiento en producción.

// Optimizaciones de Node.js para producción
// cluster.js - Utilizar múltiples núcleos
const cluster = require('cluster');
const os = require('os');

if (cluster.isMaster) {
  const numCPUs = os.cpus().length;

  console.log(`Master ${process.pid} is running`);
  console.log(`Forking ${numCPUs} workers...`);

  // Crear worker por CPU
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    console.log(`Worker ${worker.process.pid} died`);
    cluster.fork(); // Reiniciar worker
  });
} else {
  // Código del worker
  const app = require('./app');
  app.listen(3000);
}
// PM2 para gestión de procesos
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'my-app',
    script: './bin/www',
    instances: 'max', // Una instancia por CPU
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'development',
      PORT: 3000
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true,
    watch: false,
    max_memory_restart: '1G',
    restart_delay: 4000,
    autorestart: true
  }]
};

// Comandos PM2
// pm2 start ecosystem.config.js --env production
// pm2 monit
// pm2 logs
// pm2 reload ecosystem.config.js
// pm2 stop ecosystem.config.js