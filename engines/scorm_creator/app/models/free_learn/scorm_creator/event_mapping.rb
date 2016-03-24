module FreeLearn
	module ScormCreator
		class EventMapping < ActiveRecord::Base
		  belongs_to :game
		  belongs_to :game_template_events
		  belongs_to :lo, :class_name => 'FreeLearn::ScormSystem::Lo'
		end
	end
end