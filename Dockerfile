# --- Stage 1: Construcción ---
FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci

# --- Stage 2: Producción ---
FROM node:18-alpine
WORKDIR /usr/src/app
COPY package*.json ./
# Instala solo dependencias necesarias de producción
RUN npm ci --only=production 
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .

# Usar el usuario sin privilegios preconfigurado en Alpine
USER node
EXPOSE 3000

CMD ["node", "server.js"]
