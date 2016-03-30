module FreeLearn
  module VishEditor
    class CourseController < FreeLearn::ApplicationController

      def show

      end
        #Method to save excursions from vish_editor
    	def save_course
            json_parsed = JSON.parse(params[:excursion][:json])
            course = Course.new
            course.json = json_parsed
            course.save

            render status: :ok
    	end

    end
  end
end
