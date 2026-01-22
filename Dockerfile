FROM node:18-alpine
RUN npm install pm2 -g
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
# Cambiamos esto para usar PM2
CMD ["pm2-runtime", "app.js"]