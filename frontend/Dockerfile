FROM node:16

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

# Use the Docker environment file
COPY .env.docker .env

# Fix permissions for ESLint cache
RUN mkdir -p /app/node_modules/.cache && \
    chmod -R 777 /app/node_modules/.cache

# Expose port 3001
EXPOSE 3001

# Set environment variables
ENV ESLINT_NO_DEV_ERRORS=true \
    PORT=3001 \
    WDS_SOCKET_PORT=0 \
    NODE_ENV=development \
    BROWSER=none

# Start the app
CMD ["npm", "start"]
