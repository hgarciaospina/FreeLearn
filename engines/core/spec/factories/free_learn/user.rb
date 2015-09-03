require 'faker'

module FreeLearn
	FactoryGirl.define do
		factory :user, class: 'FreeLearn/User' do |f|
			f.email { Faker::Internet.email }
			password 'password'
			password_confirmation 'password'
			admin false
		end
		factory :admin, parent: :user do |f|
			admin true
		end

	end

end