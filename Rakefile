require 'rspec/core/rake_task'

task default: %w[spec build]

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
