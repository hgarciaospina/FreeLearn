module FreeLearn
  module VishEditor
    class CourseController < FreeLearn::ApplicationController

       def new
            respond_to  do |format|
                format.html
                format.full{render :layout => "veditor.full"}
                format.json{
                  render :json => {:url => "/course/:id", :uploadPath => "/course/:id", :edit_path => "/course/:id/edit", :id => course.id}
                }
            end
       end

       def create
            json_parsed = JSON.parse(params[:excursion][:json])
            course = Course.new

            #Parse Json and add to ease accessor TODO: add as before_filter
            author= User.find(json_parsed["author"]["vishMetadata"]["id"])
            course.free_learn_user_id = author.id
            course.title = json_parsed["title"]
            course.description = json_parsed["description"]
            course.json = json_parsed
            course.save!

            if params[:draft] == "true"
              render :json => {:url => "/course/" + course.id.to_s, :uploadPath => "/course/" + course.id.to_s, :editPath => "/course/" + course.id.to_s+"/edit", :id => course.id}
            else
              convertToScormFile(course)
            end
        
        end

        def edit
            @course = Course.find(params[:id])
            respond_to do |format|
                format.full{ render :layout => "veditor.full" }

                format.json{
                  render :json => {:url => "/course/:id", :uploadPath => "/course/:id", :edit_path => "/course/:id/edit", :id => course.id}
                }
            end
        end

        def show
            respond_to do |format|
                format.html
                format.full{render :layout => "veditor.full"}
                format.scorm{
                      @course = Course.find(params[:id])
                      scormVersion = (params["version"].present? and ["12","2004"].include?(params["version"])) ? params["version"] : "2004"
                      @course.to_scorm(self)
                      #@course.increment_download_count
                      send_file @course.scormFilePath(scormVersion), :type => 'application/zip', :disposition => 'attachment', :filename => ("scorm" + scormVersion + "-#{@course.id}.zip")
                }
            end

        end

        def update
          course = Course.find(params[:id])
          json_parsed = JSON.parse(params[:excursion][:json])

          course.title = json_parsed["title"]
          course.description = json_parsed["description"]
          course.json = json_parsed
          course.save!
          
          if params[:draft] == "true"
            render :json => {:url => "/course/" + course.id.to_s, :uploadPath => "/course/" + course.id.to_s, :editPath => "/course/" + course.id.to_s+"/edit", :id => course.id}
          else
            convertToScormFile(course)
            render :json => {:url => "/course/" + course.id.to_s, :uploadPath => "/course/" + course.id.to_s, :editPath => "/course/" + course.id.to_s+"/edit", :id => course.id}
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

      private

      def convertToScormFile(course)
        @course = course
        folder_path = @course.to_scorm(self)
        title = course.title || "Other than"
        description = course.description || "Cooldescription"
        FreeLearn::ScormSystem::ScormFile.create!  :name  => title, :description   => description,:avatar_url => "/images/rabbittakeaway_300.jpg",:source =>  File.open(folder_path)
      end
      
    end
  end
end
