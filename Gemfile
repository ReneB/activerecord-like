source 'https://rubygems.org'

gem 'activerecord', '>= 4.0.0'

group :test do
  gem 'rake'

  # for CRuby, Rubinius, including Windows and RubyInstaller
  gem 'sqlite3', :platform => [:ruby, :mswin, :mingw]

  # for JRuby
  gem 'jdbc-sqlite3', :platform => :jruby

  gem 'minitest', '>= 3'
end

gemspec
