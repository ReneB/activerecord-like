#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'appraisal'

Rake::TestTask.new do |t|
  t.libs = ["test"]
  t.pattern = "test/**/*_test.rb"

  # also warn about bad practices and such
  t.ruby_opts = ['-w']
end

if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
  task :default do
    sh "appraisal install && rake appraisal test"
  end
else
  task :default =>  [:test]
end

