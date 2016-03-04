FreeLearn::Core::Engine.routes.draw do
	get "editor" => "routing#editor"
	get "viewer" => "routing#viewer_full"
	get "viewer_scorm" => "routing#viewer_scorm"
end