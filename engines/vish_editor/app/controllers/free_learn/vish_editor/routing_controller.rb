module FreeLearn
	module VishEditor
		class RoutingController < ApplicationController

			def editor
				render "/editor"
			end
			
			def editor_full
				respond_to do |format|
					format.full { render "/veditor.full"}
				end
			end

			def viewer_full
				respond_to do |format|
					format.full { render partial: "/vish_viewer.full"}
				end
			end

			def viewer_scorm
				respond_to do |format|
					format.full { render partial: "/vish_viewer_scorm.full"}
				end
			end
		
		end
	end
end