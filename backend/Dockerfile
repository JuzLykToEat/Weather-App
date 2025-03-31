# Dockerfile

# Use an official Ruby image
FROM ruby:3.0.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the entire application
COPY . .

# Precompile assets for production
RUN bundle exec rake assets:precompile

# Expose port 3001
EXPOSE 3001

# Command to start the server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
# CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"]
