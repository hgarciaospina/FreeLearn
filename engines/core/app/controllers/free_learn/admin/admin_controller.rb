module FreeLearn
	module Admin
		class AdminController < ApplicationController
			def index
				@users = FreeLearn::User.ordered
			end
		end
	end
end