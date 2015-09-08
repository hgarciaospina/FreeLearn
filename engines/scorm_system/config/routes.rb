FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorms' do
		resources :scorms
	end
end