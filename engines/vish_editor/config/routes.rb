FreeLearn::Core::Engine.routes.draw do
	scope module: 'vish_editor' do



    #layouts?
    get "editor" => "routing#editor"
		get "editor_full" => "routing#editor_full", :format => :full
		get "viewer" => "routing#viewer_full"
		get "viewer_scorm" => "routing#viewer_scorm"

    #API
    get "course/:id" => "course#show" #TODO
    get "course/:id/edit" => "course#edit" #TODO
    post "upload_course" => "course#save_course"

	end
end
