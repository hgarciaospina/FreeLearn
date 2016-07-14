FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorm_creator' do
		
		resources :scorm_file
		resources :game
		resources :game_template
		resources :lo
		get 'games', to: "api#index"
		get 'games_gallery', to: "api#gallery"
		get 'lo/:id/metadata' => 'lo#metadata'

	end
end