source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2"

gem "rails", "~> 7.1"
gem "activerecord-sqlserver-adapter", "~> 7.1"
gem "tiny_tds"

# Auth
gem "jwt"
gem "bcrypt", "~> 3.1"

# Serialization
gem "jsonapi-serializer"

# Pagination
gem "pagy", "~> 6.0"

# Search / filtering
gem "ransack"

# Background jobs
gem "sidekiq"
gem "redis"

# Soft delete
gem "discard", "~> 1.4"

# Rack middleware
gem "rack-cors"
gem "rack-attack"

# File storage
gem "aws-sdk-s3", require: false

# Environment variables
gem "dotenv-rails", groups: [:development, :test]

gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end

group :development do
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "brakeman", require: false
end
