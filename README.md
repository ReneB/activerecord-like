# ActiveRecord::Like

An Active Record Plugin that allows chaining a more DSL-style 'like' or 'not-like' query to an ActiveRecord::Base#where. Requires Rails 4 beta or higher.

This plugin has been salvaged from the stellar work done by @amatsuda and @claudiob. Most of the code was previously in Active Record master, but was subsequently removed due to, amongst other, scope creep.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-like'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-like

## Usage

Given a class Post and the WhereChain work in Active Record, this plugin allows code like:

    Post.where.like(title: "%rails%")

and

    Post.where.not_like(title: "%rails%")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure the tests run. I will not merge commits that change code without testing the new code. Running the tests is as easy as running `bundle && rake` - if this does not work, consider it a bug and report it.
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
