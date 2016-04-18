$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "free_learn/core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "free_learn_core"
  s.version     = FreeLearn::Core::VERSION
  s.authors     = ["abenitoc"]
  s.email       = ["vermibeto@gmail.com"]
  s.homepage    = "http://twitter.com/berto_abc"
  s.summary     = "Core features for FreeLearn"
  s.description = "Core features for FreeLearn"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_dependency 'sass-rails', "~> 5.0.1"
  s.add_dependency 'bootstrap-sass', "~> 3.3.3"
  s.add_dependency 'autoprefixer-rails', "~> 5.1.5"
  s.add_dependency 'devise', "~> 3.4.1"
  s.add_dependency 'cancan', "~> 1.6.10"
  s.add_dependency "jquery"
  s.add_dependency 'font-awesome-rails'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "faker"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "minitest"

end
