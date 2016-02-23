FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorm_system' do
		resources :scorm_file
		resources :lo
		get 'lo/:id/metadata' => 'lo#metadata'
	end
end
