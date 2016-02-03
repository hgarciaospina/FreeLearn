class ApiController < ApplicationController

	#
	# API DEFINITION
	#
	# => JSON PARAMS: 
	# => NAME
	# => AVATAR URL (OPTIONAL)
	# => QUESTIONS 
	# => GAME SELECTION
	# 
	
	def json_game
		json_params = JSON.parse(params[:json])

		gT = GameTemplate.find_by_id(params[:g_template_id]);

	    name = params[:game][:name] ? params[:game][:name] : gT.name
	    avatar_url = params[:game][:avatar_url] ? params[:game][:avatar_url] : gT.avatar_url    
	    gameInstance = Game.create! :name=>name, :description=>gT.description, :avatar_url=>avatar_url, :game_template_id=>params[:g_template_id]	

	    #TODO: Create scorms from questions, quizzes and add here. Use Vish Editor or similar.
	    los = [];
=begin
	    JSON.parse(params[:scorms_ids]).each do |scorm_id|
	      sf = ScormFile.find_by_id(scorm_id)
	      sf.los.each do |lo|
	        los.push(lo)
	      end
	    end
=end

		 #Event mapping for the game instace

	    #Add all los to -1 event_id (to generate the LO_list)
	    los.each do |lo|
	      EventMapping.create! :game_id => gameInstance.id, :game_template_event_id => -1, :lo_id => lo.id
	    end


	    #Map all of the events to random LOs
	    gT.game_template_events.each do |event|
	      EventMapping.create! :game_id => gameInstance.id, :game_template_event_id => event.id, :lo_id => -2
	    end

	end
end