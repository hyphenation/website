# if ['development', 'test'].include? ENV['RACK_ENV']
begin
  require 'rspec/core/rake_task'
  task default: %w[spec build]
rescue LoadError # TODO Something better than that
  task default: %[build]
end

$LOAD_PATH << File.expand_path('../lib', __FILE__)

task :spec do
  RSpec::Core::RakeTask.new
end

task :build do
  system("git submodule update")
  require "pages"
  include Pages
  mainpage
  puts "Languages: #{@languages.map { |lang| lang[:bcp47] }}"
end
