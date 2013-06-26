# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_record/like/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "activerecord-like"
  gem.version       = ActiveRecord::Like::VERSION
  gem.authors       = ["René van den Berg"]
  gem.email         = ["r.van.den.berg@ogd.nl"]
  gem.description   = %q{An ActiveRecord plugin providing a higher-level abstraction for SQL 'LIKE' queries}
  gem.summary       = %q{ActiveRecord::Like provides ActiveRecord::Base with where.like(attribute: string)-style extensions. This functionality was, at one point, included in Rails-master, but subsequently removed. Since the feature seemed to be in some demand, I thought I'd try my hand at building an ActiveRecord plugin}
  gem.homepage      = "http://github.com/ReneB/activerecord-like"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "minitest",     ">= 3"
  gem.add_development_dependency "sqlite3",      "~> 1.3"

  gem.add_dependency             "activerecord", ">= 4.0.0"
end
