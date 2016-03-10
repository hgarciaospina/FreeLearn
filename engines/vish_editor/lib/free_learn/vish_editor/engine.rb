module FreeLearn
  module VishEditor
    class Engine < ::Rails::Engine
      isolate_namespace VishEditor

      paths["app/views"] << "app/views/free_learn/vish_editor"
    
      config.assets.enabled = true
      initializer "free_learn.vish_editor.assets.precompile" do |app|
        app.config.assets.precompile += %w( application.js application.css )
      end

      config.local_asset_js_path = File.join(root, "app", "assets", "javascripts").to_s
      config.local_asset_css_path = File.join(root, "app", "assets", "stylesheets").to_s


    end
  
  end
end



