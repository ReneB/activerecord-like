require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'active_record/like'

# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
PG_SPEC = {
  :adapter  => 'postgresql',
  :host     => 'localhost',
  :database => 'activerecord_like_test',
  :username => 'postgres',
  :encoding => 'utf8'
}

# drops and create need to be performed with a connection to the 'postgres' (system) database
ActiveRecord::Base.establish_connection(PG_SPEC.merge('database' => 'postgres', 'schema_search_path' => 'public'))
# drop the old database (if it exists)
ActiveRecord::Base.connection.drop_database PG_SPEC[:database] rescue nil
# create new
ActiveRecord::Base.connection.create_database(PG_SPEC[:database])
ActiveRecord::Base.establish_connection(PG_SPEC)

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
    t.string :category
  end
end

class Post < ActiveRecord::Base
end
