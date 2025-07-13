# Fix for uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger error
# when using Rails 6.0 with Ruby 2.7
require 'logger'
require 'active_support'

unless defined?(ActiveSupport::LoggerThreadSafeLevel::Logger)
  ActiveSupport.on_load(:before_initialize) do
    ActiveSupport::LoggerThreadSafeLevel.const_set(:Logger, ::Logger)
  end
end
