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

  s.add_development_dependency "sqlite3"
end
