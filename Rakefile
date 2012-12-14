#!/usr/bin/env rake
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ["test"]
  t.pattern = "test/**/*_test.rb"

  # also warn about bad practices and such
  t.ruby_opts = ['-w']
end

task :default => :test
