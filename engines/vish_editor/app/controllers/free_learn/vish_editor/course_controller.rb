module FreeLearn
  module VishEditor
    class CourseController < FreeLearn::ApplicationController
        
        def new
            new! do |format|
                format.html{
                    redirect_to new_course_path(@course)
                }
            end
        end
        
        def edit
            edit! do |format|
                format.html{
                    redirect_to edit_course_path(@course)
                }
            end
        end
        
        def show
            show! do |format|
                format.html{
                    redirect_to course_path(@course)
                }
            end
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
