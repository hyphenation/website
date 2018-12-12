require 'tex/hyphen/language'
include TeX::Hyphen

begin
  require 'rspec/core/rake_task'
  task default: %w[spec count_languages]
rescue LoadError # TODO Something better than that
  task default: %[count_languages]
end

task :spec do
  RSpec::Core::RakeTask.new
end

task :count_languages do
  puts "Languages: #{Language.all.map { |bcp47, lang| bcp47 }.sort}"
end
