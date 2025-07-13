#!/bin/bash
set -e

# Print Ruby and bundler version for debugging
echo "Ruby version:"
ruby -v
echo "Bundler version:"
bundle -v

# Fix bundler configuration issues
echo "Fixing bundler configuration..."
# Remove any conflicting bundle config files
if [ -f /usr/local/bundle/config ]; then
  echo "Removing conflicting bundle config at /usr/local/bundle/config"
  rm -f /usr/local/bundle/config
fi

# Set bundle config directly through bundler
echo "Setting bundle path to /usr/local/bundle"
bundle config set --global path '/usr/local/bundle'
bundle config set --global bin '/usr/local/bundle/bin'

# Verify gems are accessible
echo "Verifying gem configuration..."
bundle config get path
echo "Gems directory contents:"
ls -la /usr/local/bundle
echo "Installing gems if needed..."
bundle install

# Remove a potentially pre-existing server.pid for Rails
rm -f /rails/tmp/pids/server.pid

# Clean up vendor directory to ensure we're only using the Docker volume for gems
echo "Cleaning up vendor directory..."
rm -rf /rails/vendor/bundle
mkdir -p /rails/vendor
touch /rails/vendor/.keep

# Clean up bootsnap cache for clean startup
echo "Cleaning up bootsnap cache..."
rm -rf /rails/tmp/cache/bootsnap*

# Create necessary directories with proper permissions
echo "Setting up directory permissions..."
mkdir -p /rails/tmp/pids /rails/log /rails/db
chmod -R 777 /rails/tmp /rails/log /rails/db

# Set up database if it doesn't exist
echo "Setting up the database..."
bundle exec rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile)
echo "Starting Rails server..."
exec "$@"
