module FreeLearn::ScormSystem
	class ApiController < ApplicationController

		def gallery
			render "main_views/gallery"
		end

		def scorm_gallery
			render "main_views/scorm_gallery"
		end
		
	end
end