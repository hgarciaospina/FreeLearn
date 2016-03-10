module FreeLearn
	module VishEditor
		class RoutingController < ApplicationController

			def editor
				render "excursions/editor"
			end
			
			def editor_full
				render "excursions/vish_editor.full"
			end

			def viewer_full
				render "excursions/vish_viewer"
			end

			def viewer_scorm
				render "excursions/vish_viewer_scorm"
			end
		
		end
	end
end