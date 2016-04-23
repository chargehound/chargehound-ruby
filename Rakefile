require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new do |test|
  test.libs.push 'lib', 'test'
  test.pattern = './test/**/*_test.rb'
end

task default: [:rubocop, :test]
