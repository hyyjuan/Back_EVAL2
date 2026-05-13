FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

FROM node:18-alpine AS runner
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/server.js ./
RUN npm ci --omit=dev
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
CMD ["node", "server.js"]