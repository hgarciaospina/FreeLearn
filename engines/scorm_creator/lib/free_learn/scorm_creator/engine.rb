module FreeLearn
  module ScormCreator
    class Engine < ::Rails::Engine
      isolate_namespace FreeLearn::ScormCreator
      paths["app/views"] << "app/views/free_learn/scorm_creator"
    
      initializer :append_migrations do |app|
        unless app.root.to_s.match(root.to_s)
          config.paths["db/migrate"].expanded.each do |p|
            app.config.paths["db/migrate"] << p
          end
        end
      end
    
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w{ stylesheets/free_learn/scorm_creator/application.css }
        Rails.application.config.assets.precompile += %w{ javascripts/free_learn/scorm_creator/application.js }
        Rails.application.config.assets.paths << root.join("app", "assets")
      end

      config.to_prepare do
        Dir.glob(Engine.root.join("app", "decorators", "**", "*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
    


    end
  
  end
end



