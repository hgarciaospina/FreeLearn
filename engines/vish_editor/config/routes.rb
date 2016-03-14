FreeLearn::Core::Engine.routes.draw do
	scope module: 'vish_editor' do
		get "editor" => "routing#editor"
		get "editor_full" => "routing#editor_full", :format => :full
		get "viewer" => "routing#viewer_full"
		get "viewer_scorm" => "routing#viewer_scorm"
	end
end