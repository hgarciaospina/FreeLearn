$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
#require "free_learn/vish_editor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vish_editor"
  s.version     = "0.9.2"
  s.authors     = ["abenitoc"]
  s.email       = ["bertocode@gmail.com"]
  s.homepage    = "http://www.twitter.com/berto_abc"
  s.summary     = "Vish Editor as an engine"
  s.description = "Vish Editor"
  s.license     = "MIT"

  s.files = Dir["{app,config,db, extras,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "free_learn_core"
  s.add_dependency "free_learn_scorm_system"
  s.add_dependency "deface"
  s.add_dependency "paperclip"
  
end
