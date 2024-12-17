require 'bundler/setup'

if ENV["COVERALLS"]
  require "simplecov"
  require "simplecov-lcov"

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::LcovFormatter]
  )

  SimpleCov.start do
    add_filter "test/"
  end
end

require 'minitest/autorun'
require 'minitest/spec'
require 'active_record/like'

module Test
  module Postgres
    def connect_db
      ActiveRecord::Base.establish_connection(postgres_config)
    end

    def drop_and_create_database
      # drops and create need to be performed with a connection to the 'postgres' (system) database
      temp_connection = postgres_config.merge(database: 'postgres', schema_search_path: 'public')
      ActiveRecord::Base.establish_connection(temp_connection)

      # drop the old database (if it exists)
      ActiveRecord::Base.connection.drop_database(database_name) rescue nil

      # create new
      ActiveRecord::Base.connection.create_database(database_name)
    end

    def postgres_config
      @postgres_config ||= {
        adapter:   'postgresql',
        database:  database_name,
        username:  'postgres'
      }
    end

    def database_name
      'activerecord_like_test'
    end
  end

  module SQLite3
    def connect_db
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    end

    def drop_and_create_database
      # NOOP for SQLite3
    end
  end

  module MySQL
    def connect_db
      ActiveRecord::Base.establish_connection(mysql_config)
    end

    def drop_and_create_database
      temp_connection = mysql_config.merge(database: 'mysql')

      ActiveRecord::Base.establish_connection(temp_connection)

      # drop the old database (if it exists)
      ActiveRecord::Base.connection.drop_database(database_name) rescue nil

      # create new
      ActiveRecord::Base.connection.create_database(database_name)
    end

    def mysql_config
      @mysql_config ||= {
        adapter:   'mysql2',
        database:  database_name,
        username:  db_user_name,
      }
    end

    def db_user_name
      # change this to whatever your config requires
      ENV['TRAVIS'] ? 'travis' : 'root'
    end

    def database_name
      'activerecord_like_test'
    end
  end
end

case ENV['DB']
when 'pg'
  include Test::Postgres
when 'sqlite3'
  include Test::SQLite3
when 'mysql'
  include Test::MySQL
else
  puts "No DB environment variable provided, testing using SQLite3"
  include Test::SQLite3
end

drop_and_create_database

connect_db

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
    t.string :category
  end
end

class Post < ActiveRecord::Base
end
