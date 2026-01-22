Task 2: Monitoreo y Logging (8 minutos)
Observabilidad en aplicaciones en producción.

// Winston para logging estructurado
const winston = require('winston');

// Configuración de logger
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'user-service' },
  transports: [
    // Console para desarrollo
    new winston.transports.Console({
      format: winston.format.simple()
    }),

    // Archivo para producción
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error'
    }),
    new winston.transports.File({
      filename: 'logs/combined.log'
    })
  ]
});

// Uso en aplicación
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info('Request completed', {
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: `${duration}ms`,
      userAgent: req.get('User-Agent')
    });
  });

  next();
});

// Logging de errores
app.use((error, req, res, next) => {
  logger.error('Request error', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method
  });

  res.status(500).json({ error: 'Internal server error' });
});

module.exports = logger;
// Health checks para contenedores
const express = require('express');
const router = express.Router();

// Health check básico
router.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: process.env.npm_package_version
  });
});

// Health check detallado
router.get('/health/detailed', async (req, res) => {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    externalAPI: await checkExternalAPI()
  };

  const isHealthy = Object.values(checks).every(check => check.healthy);

  res.status(isHealthy ? 200 : 503).json({
    status: isHealthy ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString(),
    checks
  });
});

async function checkDatabase() {
  try {
    // Verificar conexión a DB
    await database.query('SELECT 1');
    return { healthy: true };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}

async function checkRedis() {
  try {
    await redis.ping();
    return { healthy: true };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}

async function checkExternalAPI() {
  try {
    const response = await fetch('https://api.thirdparty.com/health');
    return { healthy: response.ok };
  } catch (error) {
    return { healthy: false, error: error.message };
  }
}

module.exports = router;