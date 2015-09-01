module FreeLearn
	module Admin
		class UsersController < AdminController
			def index
				@users = FreeLearn::User.ordered
			end
		end
	end
end