FROM node:24-bookworm AS builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y python3 make g++ build-essential libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


FROM node:24-slim

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/server.js ./server.js
COPY --from=builder /app/masqr.js ./masqr.js
COPY --from=builder /app/public ./public
COPY --from=builder /app/dist ./dist

ENV PORT=2345

EXPOSE 2345

CMD ["node", "server.js"]
