module FreeLearn
	module VishEditor
		class RoutingController < ApplicationController

			def editor
				render "/editor"
			end
			
			def new_editor
				render "/new_editor"
			end

			def editor_full
				respond_to do |format|
					format.full { render "/_vish_editor.full", :layout => 'veditor' }
				end
			end

			def viewer_full
				respond_to do |format|
					format.full { render partial: "/vish_viewer.full", :layout => 'veditor'}
				end
			end

			def viewer_scorm
				respond_to do |format|
					format.full { render partial: "/vish_viewer_scorm.full", :layout => 'veditor'}
				end
			end
		
		end
	end
end