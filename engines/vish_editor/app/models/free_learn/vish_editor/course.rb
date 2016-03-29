require 'builder'

module FreeLearn::VishEditor
  class Course < ActiveRecord::Base

    validates_presence_of :json



  ####################
  ## Model methods
  ####################

  def to_json(options=nil)
    json
  end



  end
end
