source 'https://rubygems.org'

gem 'activerecord', '>= 4.0.0'

group :test do
  gem 'rake'

  case ENV['DB']
  when 'pg'
    gem 'pg'
  when 'mysql'
    gem 'mysql2'
  else
    gem 'sqlite3'
  end

  gem 'minitest', '>= 3'
end

gemspec
