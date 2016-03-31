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
            course.save!

            #TODO: Needs to implement visualization
            # => json_path
            # => edit_path
            render :json => { :url => "/path_to_course",
                      :uploadPath => "/todo.json",
                      :editPath => "/edit_todo",
                      :id => course.id
                    }
    	end

    end
  end
end
