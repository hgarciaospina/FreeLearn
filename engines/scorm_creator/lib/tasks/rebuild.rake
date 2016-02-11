namespace :sgame do
	task :rebuild do
		desc "Rebuild..."

			system "rake db:drop"
			system "rake db:create" 
			system "rake db:migrate"
			system "rm -rf #{FreeLearn::ScormCreator::Engine.root}/public/scorm/*"
			system "rake db:populate"

		puts "Rebuild finish"
	end
end