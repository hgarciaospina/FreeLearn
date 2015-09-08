$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "free_learn/scorm_system/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "free_learn_scorm_system"
  s.version     = FreeLearn::ScormSystem::VERSION
  s.authors     = ["abenitoc"]
  s.email       = ["vermibeto@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FreeLearn::ScormSystem."
  s.description = "TODO: Description of FreeLearn::ScormSystem."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_dependency "deface"
  s.add_dependency "free_learn_core"
  s.add_development_dependency "sqlite3"
end
