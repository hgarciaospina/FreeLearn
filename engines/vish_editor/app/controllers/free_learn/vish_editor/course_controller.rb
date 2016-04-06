module FreeLearn
  module VishEditor
    class CourseController < FreeLearn::ApplicationController
        
       def new
            respond_to  do |format|
                format.html{
                  redirect_to new_course_path(@course)
                }
                format.json{
                    render :json => {:url => "/course/:id", :uploadPath => "/course/:id", :edit_path => "/course/:id/edit", :id => course.id}
                }
            end
       end
        
       def create 
  
            json_parsed = JSON.parse(params[:excursion][:json])
            course = Course.new
            course.json = json_parsed
            course.save!
       
            render :json => {:url => "/course/:id", :uploadPath => "/course/:id", :edit_path => "/course/:id/edit", :id => course.id}
            
        end
        
        def edit
            respond_to do |format|
                format.html{
                    redirect_to edit_course_path(@course)
                }
            end
        end
        
        def show

            respond_to do |format|
                format.html
                format.full{render :layout => "veditor.full"}
                format.scorm{render :layout => "show.scorm"}
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
