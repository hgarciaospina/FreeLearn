FreeLearn::Core::Engine.routes.draw do
  devise_for :users, class_name: "FreeLearn::User", module: :devise
    #devise_for :users, class_name: "FreeLearn::User", module: :devise
	root to: "dashboard#index"
end
