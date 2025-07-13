ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Load monkey patches for Ruby 3.0.6 and Rails 7.0 compatibility
require_relative 'monkey_patches'

# Enable bootsnap for better performance
require "bootsnap"
Bootsnap.setup(
  cache_dir: "tmp/cache",
  development_mode: ENV["RAILS_ENV"] == "development",
  load_path_cache: true,
  compile_cache_iseq: true,
  compile_cache_yaml: true
)
