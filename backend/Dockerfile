FROM ruby:3.0.6

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev nodejs npm sqlite3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /rails

# Install specific bundler version
RUN gem install bundler:2.2.33

# Set environment variables
ENV BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle \
    RAILS_ENV=development \
    RACK_ENV=development

# Copy gemfiles first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Create required directories with proper permissions
RUN mkdir -p tmp/pids log db
RUN chmod -R 777 tmp log db

# Make entrypoint executable
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Configure the main process
EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
