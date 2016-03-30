require 'builder'

module FreeLearn::VishEditor
  class Course < ActiveRecord::Base
  #Faker of Excursion as model for VISH Editor Engine
    validates_presence_of :json



  ####################
  ## Model methods
  ####################

  def to_json(options=nil)
    json
  end



  end
end
