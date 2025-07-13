# Monkey patches for Ruby 3.0.6 and Rails 7.0.8 compatibility

# Ensure Logger is available
require 'logger'

# Monkey patch for Rails 7.0.8 with Ruby 3.0.6
module ActiveSupport
  # Redefine LoggerThreadSafeLevel to ensure Logger is properly defined
  remove_const :LoggerThreadSafeLevel if defined?(LoggerThreadSafeLevel)
  
  module LoggerThreadSafeLevel
    # Set Logger to the Ruby standard library version
    Logger = ::Logger
  end
end
