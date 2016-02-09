FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorm_creator' do
		resources :game
	end
end