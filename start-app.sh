#!/bin/bash

# Exit the script on any command failure
set -e

echo "Starting Currency Converter Application..."

# Function to clean up background processes on exit
cleanup() {
  echo "Shutting down all processes..."
  kill $(jobs -p) 2>/dev/null || true
  exit
}

# Set up the trap to catch SIGINT (Ctrl+C) and other exit signals
trap cleanup SIGINT SIGTERM EXIT

# Check if the user wants to rebuild the images
if [ "$1" == "--rebuild" ] || [ "$1" == "-r" ]; then
  echo "Rebuilding Docker images..."
  docker-compose build --no-cache
  REBUILD_RESULT=$?
  if [ $REBUILD_RESULT -ne 0 ]; then
    echo "ERROR: Failed to rebuild Docker images."
    exit $REBUILD_RESULT
  fi
  echo "Docker images rebuilt successfully."
fi

# Start the application using Docker Compose
echo "Starting containers..."
docker-compose up -d

echo "\nApplication services are starting..."
echo "Please wait a moment while containers initialize..."

# Check backend health for up to 30 seconds
echo "\nChecking backend health..."
MAX_ATTEMPTS=30
ATTEMPT=0
BACKEND_READY=false

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ((ATTEMPT++))
  echo -n "."
  
  # Check if backend API is responding
  curl -s http://localhost:3000/api/v1/health > /dev/null
  if [ $? -eq 0 ]; then
    BACKEND_READY=true
    echo "\nBackend is ready!"
    break
  fi
  
  sleep 1
done

if [ "$BACKEND_READY" = false ]; then
  echo "\nWARNING: Backend health check timed out. It might still be initializing."
  echo "Check logs with: docker-compose logs -f backend"
fi

echo "\n\nCurrency Converter is now available at:"
echo "- Frontend: http://localhost:3001"
echo "- Backend API: http://localhost:3000/api/v1"
echo "- Backend Health: http://localhost:3000/api/v1/health"
echo "\nTo view logs, run: docker-compose logs -f"
echo "To stop the application, run: docker-compose down"
echo "\nHappy converting! 💱"
