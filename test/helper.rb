require 'bundler/setup'
require 'minitest/spec'
require 'minitest/autorun'
require 'active_record/like'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
    t.string :category
  end
end

class Post < ActiveRecord::Base
end
