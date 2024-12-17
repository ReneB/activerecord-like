# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_record/like/version', __FILE__)

main_author_name = "PikachuEXE"
gem_name = "activerecord-like"

Gem::Specification.new do |gem|
  gem.name          = gem_name
  gem.version       = ActiveRecord::Like::VERSION
  gem.authors       = [
    "René van den Berg",
    main_author_name,
  ]
  gem.email         = %w[rene.vandenberg@ogd.nl git@pikachuexe.net]
  gem.description   = %q{An ActiveRecord plugin providing a higher-level abstraction for SQL 'LIKE' queries}
  gem.summary       = %q{ActiveRecord::Like provides ActiveRecord::Base with where.like(attribute: string)-style extensions. This functionality was, at one point, included in Rails-master, but subsequently removed. Since the feature seemed to be in some demand, I thought I'd try my hand at building an ActiveRecord plugin}
  gem.homepage      = "http://github.com/#{main_author_name}/#{gem_name}"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency             "activerecord", ">= 7.0.0", "< 9.0"

  # Required for Travis build to pass
  gem.add_development_dependency "pg"
  gem.add_development_dependency "mysql2"
  gem.add_development_dependency "sqlite3"

  gem.add_development_dependency "rake"

  gem.add_development_dependency "minitest", ">= 3"

  gem.add_development_dependency "appraisal", "~> 2.0"

  gem.add_development_dependency "simplecov", ">= 0.22"
  gem.add_development_dependency "simplecov-lcov", ">= 0.8"

  gem.add_development_dependency "gem-release", ">= 2.0"
end
