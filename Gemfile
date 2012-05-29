source :rubygems

gem 'rake'

gem 'bundler_local_development', :group => :development, :require => false
begin
  require 'bundler_local_development'
rescue LoadError
end

gemspec

gem 'cloudfuji', :git => 'git://github.com/cloudfuji/cloudfuji_client.git'

group :test, :development do
  gem 'pg'  # Default database for testing
end
