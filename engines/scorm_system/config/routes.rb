FreeLearn::Core::Engine.routes.draw do
	scope module: 'scorm_system/scorm' do
		resources :scorms
	end
end
