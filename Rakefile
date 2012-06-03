require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'vizi_translator'
  s.version = '0.1.0'
  s.summary = "Language translator that provides a wrapper to the Frengly on-line service"
  s.description = "This gem module provides a classes to support the language translation of text files or text strings.
  The Frengly on-line service requires registration and prvoides access with a username and password.
  The gem module uses the NET::HTTP library to access the Frengly service"
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*_test.rb")
  s.author = "Al Kivi"
  s.homepage = "http://www.vizitrax.com"
  s.email = "al.kivi@vizitrax.com"
  s.has_rdoc = true
  s.required_ruby_version = '>= 1.8.7'
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ViziTranslator'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end

