# Stage 1: Build the app
FROM node:18 AS builder

WORKDIR /app

# Copy and install all dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the codebase and build the app
COPY . .
RUN npm run build

# Stage 2: Create a smaller production image
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy necessary files from builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]

