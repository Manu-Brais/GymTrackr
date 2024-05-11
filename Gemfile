source "https://rubygems.org"
ruby "3.3.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

gem "bcrypt"
gem "graphql"
gem "jwt"
gem "pg"
gem "puma", ">= 5.0"
gem "propshaft"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development do
  gem "graphiql-rails"
end

group :test do
  gem "rspec"
  gem "rspec-rails"
end

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "faker"
  gem "standard"
end
