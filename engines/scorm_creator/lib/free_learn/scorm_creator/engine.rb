module FreeLearn
  module ScormCreator
    class Engine < ::Rails::Engine
      isolate_namespace ScormCreator

      paths["app/views"] << "app/views/free_learn/scorm_creator"
    
      initializer :append_migrations do |app|
        unless app.root.to_s.match(root.to_s)
          config.paths["db/migrate"].expanded.each do |p|
            app.config.paths["db/migrate"] << p
          end
        end
      end

      config.assets.enabled = true
      initializer "free_learn.scorm_creator.assets.precompile" do |app|
        app.config.assets.precompile += %w( application.js application.css )
      end
      config.local_asset_js_path = File.join(root, "app", "assets", "javascripts").to_s
      config.local_asset_css_path = File.join(root, "app", "assets", "stylesheets").to_s

      if Rails.application.config.serve_static_assets
        app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
      end

      config.to_prepare do
        Dir.glob(Engine.root.join("app", "decorators", "**", "*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
    
      end
    


    end
  
  end
end



