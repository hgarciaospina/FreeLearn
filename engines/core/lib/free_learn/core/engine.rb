module FreeLearn
	module Core
	  class Engine < ::Rails::Engine
	    isolate_namespace FreeLearn

	    paths["app/views"] << "app/views/free_learn"

	    initializer :append_migrations do |app|
				unless app.root.to_s.match(root.to_s)
					config.paths["db/migrate"].expanded.each do |p|
					app.config.paths["db/migrate"] << p
				end
			end
		end

	  end
	end
end
