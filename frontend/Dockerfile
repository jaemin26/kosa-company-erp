# 1. 의존성 설치 단계 (캐싱 활용)
FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package*.json ./
RUN npm ci

# 2. 빌드 단계
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# 런타임이 아닌 빌드타임(Build time)에 환경변수가 있어야 next.config.ts의 rewrites에 올바르게 구워집니다.
ENV BACKEND_URL=http://backend:8080
# Standalone 빌드 수행
RUN npm run build

# 3. 실행 단계 (최적화)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# 컨테이너 외부 연결을 위해 필수 설정
ENV HOSTNAME="0.0.0.0" 

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000
CMD ["node", "server.js"]
