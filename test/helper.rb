require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'active_record/like'

module Test
  module Postgres
    def setup_db
      database = 'activerecord_like_test'

      postgres_config = {
        adapter:   'postgresql',
        database:  database,
        username:  'postgres'
      }

      # drops and create need to be performed with a connection to the 'postgres' (system) database
      temp_connection = postgres_config.merge(database: 'postgres', schema_search_path: 'public')
      ActiveRecord::Base.establish_connection(temp_connection)

      # drop the old database (if it exists)
      ActiveRecord::Base.connection.drop_database(database) rescue nil

      # create new
      ActiveRecord::Base.connection.create_database(database)
      ActiveRecord::Base.establish_connection(postgres_config)
    end
  end

  module SQLite3
    def setup_db
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
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

setup_db

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
    t.string :category
  end
end

class Post < ActiveRecord::Base
end
