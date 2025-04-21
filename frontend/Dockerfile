# Stage 1: Build the frontend
FROM node:16-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve using Nginx
FROM nginx:alpine

# Copy build files to Nginx directory
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

