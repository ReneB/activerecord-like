# ActiveRecord::Like

[![Build Status](https://travis-ci.org/ReneB/activerecord-like.png?branch=master)](https://travis-ci.org/ReneB/activerecord-like)
[![Code Climate](https://codeclimate.com/github/ReneB/activerecord-like.png)](https://codeclimate.com/github/ReneB/activerecord-like)
[![Dependency Status](https://gemnasium.com/ReneB/activerecord-like.png)](https://gemnasium.com/ReneB/activerecord-like)
[![Gem Version](https://badge.fury.io/rb/activerecord-like.png)](http://badge.fury.io/rb/activerecord-like)

[activerecord-like on Github](https://github.com/ReneB/activerecord-like)

An Active Record Plugin that allows chaining a more DSL-style 'like' or 'not-like' query to an ActiveRecord::Base#where. Requires Rails 5 or higher.

This plugin has been salvaged from the stellar work done by @amatsuda and @claudiob, updated to ActiveRecord 5 by @PikachuEXE and 5.2 by @robotdana and then to ActiveRecord 6.1 by @nrw505. Most of the code was previously in Active Record master, but was subsequently removed due to, amongst other, scope creep (see discussion [here](https://github.com/rails/rails/commit/8d02afeaee8993bd0fde69687fdd9bf30921e805)).
Array parameter handling was added by @rzane - thanks!

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-like'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-like

## Usage

Given a class Post and the WhereChain work in Active Record, this plugin allows code like:

```ruby
Post.where.like(title: "%rails%")
Post.where.like(title: ["%ruby%", "%rails%"])
```

and

```ruby
Post.where.not_like(title: "%rails%")
Post.where.not_like(title: ["%ruby%", "%rails%"])
```

## Dependencies
ActiveRecord 5 or higher

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure the tests run. I will not merge commits that change code without testing the new code. Running the tests is as easy as running `bundle && rake` - if this does not work, consider it a bug and report it. *Testing with a specific database engine* is done using `export DB={engine}; bundle && rake` or the equivalent for your system. Supported engines are `mysql`, `sqlite3` and `pg`.
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
