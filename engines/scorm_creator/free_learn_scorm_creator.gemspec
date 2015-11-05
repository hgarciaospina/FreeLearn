$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "free_learn/scorm_creator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "free_learn_scorm_creator"
  s.version     = FreeLearn::ScormCreator::VERSION
  s.authors     = ["abenitoc"]
  s.email       = ["vermibeto@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FreeLearn::ScormCreator."
  s.description = "TODO: Description of FreeLearn::ScormCreator."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_dependency "deface"
end