module FreeLearn
  module VishEditor
    class CourseController < FreeLearn::ApplicationController

    	def save_course
            binding.pry
    		course = JSON.parse(:json)
    	end

    	def export_from_json

    	end

    end
  end
end
