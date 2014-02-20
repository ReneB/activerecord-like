require 'bundler/setup'
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
end

case ENV['DB']
when 'pg'
  include Test::Postgres
when 'sqlite3'
  include Test::SQLite3
else
  puts "No DB environment variable provided, testing using SQLite3"
  include Test::SQLite3
end

unless ENV['TRAVIS'] # if we're running on Travis, no drop/create needed
  drop_and_create_database
end

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
