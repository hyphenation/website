task default: %w[build]

$LOAD_PATH << File.expand_path('../lib', __FILE__)

task :build do
  system("cd hydra && git pull --ff-only")
  system("cd tex-hyphen && git pull --ff-only")
  require "pages"
  include Pages
  mainpage
  puts "Languages: #{@languages.map { |lang| lang[:bcp47] }.sort}"
end
