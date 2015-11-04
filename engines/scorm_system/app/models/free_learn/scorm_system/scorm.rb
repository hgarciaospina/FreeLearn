module FreeLearn
  module ScormSystem
    class Scorm < ActiveRecord::Base
    	has_attached_file :file
    end
  end
end
