FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorm_creator' do
		resources :game
		get 'games', to: "api#index"
	end
end