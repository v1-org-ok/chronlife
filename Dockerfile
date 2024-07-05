# Use an official Ruby image as a parent image
FROM ruby:3.2.0

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client && apt-get clean

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile* /app/

# Install Ruby dependencies
RUN bundle install

# Copy the main application
COPY . /app/

# Set environment variables
ENV RAILS_ENV=test
ENV DATABASE_URL="postgres://rails:password@postgres:5432/rails_test"
ENV ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=your_primary_key
ENV ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=your_deterministic_key
ENV ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=your_salt

# Command to run tests
CMD ["sh", "-c", "bin/rails db:schema:load && bin/rails db:seed && bundle exec rspec && exit"]