module FreeLearn
	module VishEditor
		class RoutingController < ApplicationController

			def editor
				render "/editor"
			end
			
			def editor_full
				render "/vish_editor.full"
			end

			def viewer_full
				render "/vish_viewer"
			end

			def viewer_scorm
				render "/vish_viewer_scorm"
			end
		
		end
	end
end