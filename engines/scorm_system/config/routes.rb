FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorm_system' do
		resources :scorm_file
		resources :lo
		get 'lo/:id/metadata' => 'lo#metadata'
		get 'gallery', to: "api#gallery"
		get 'scorm_gallery', to: "api#scorm_gallery"
	end
end
