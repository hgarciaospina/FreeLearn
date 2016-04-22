FreeLearn::Core::Engine.routes.draw do
  default_url_options :host => "localhost:3000"
  devise_for :users, class_name: "FreeLearn::User", module: :devise
	namespace :admin do
		get '/' => 'admin#index'
		resources :users, only: [:index]
	end
	root to: "dashboard#index"
end
