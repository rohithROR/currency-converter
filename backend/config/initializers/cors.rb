# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Simple configuration - allow requests from all origins
  # This is appropriate for development but should be restricted in production
  allow do
    origins '*'
    
    resource '*',
      headers: :any,
      expose: ['Access-Control-Allow-Origin'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

# Set Access-Control-Allow-Origin header on all responses
Rails.application.config.action_dispatch.default_headers = {
  'Access-Control-Allow-Origin' => '*',
  'Access-Control-Request-Method' => '%{HTTP_ACCESS_CONTROL_REQUEST_METHOD}',
  'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS, HEAD',
  'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
}

# Enable debug output for troubleshooting
Rails.application.config.log_level = :debug
