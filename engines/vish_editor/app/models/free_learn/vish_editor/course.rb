require 'builder'

module FreeLearn::VishEditor
  class Course < ActiveRecord::Base
  #Faker of Excursion as model for VISH Editor Engine
    validates_presence_of :json
      serialize :json, JSON


  ####################
  ## Model methods
  ####################

  def to_json(options=nil)
    json
  end

  def user
    FreeLearn::User.find(self.free_learn_user_id)
  end



  end
end
