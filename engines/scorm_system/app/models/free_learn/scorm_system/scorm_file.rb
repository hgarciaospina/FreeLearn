require 'scorm/package'

module FreeLearn
  module ScormSystem
    class ScormFile < ActiveRecord::Base
      #attr_accessible :created_at, :updated_at, :name, :description, :avatar_url

      has_many :los, :dependent => :destroy
      has_attached_file :source,
      					:url  => ":rails_root/public/scorm/:id/:basename.:extension",
                      	:path => ":rails_root/engines/scorm_creator/public/scorm/:id/:basename.:extension"
                        #TODO: source path is not associating correctly
    	
      after_save :extract_scorm_file

      do_not_validate_attachment_file_type :source

      def scos_ids
      	los.select{|lo| lo.scorm_type=="sco"}.collect(&:id)
      end

      def assets_ids
      	los.select{|lo| lo.scorm_type=="asset"}.collect(&:id)
      end

      def ids
        los.collect(&:id)
      end

      def extract_scorm_file
         #TODO: source path is not associating correctly
      	 Scorm::Package.open(source.path, :cleanup => false) do |pkg|
    	   # Read stuff from the package...
    	   name = pkg.manifest.default_organization.title
    	   pkg.manifest.resources.each do |resource|
    	   	 lo = Lo.new
    	   	 lo.lo_type = resource.type
    	   	 lo.scorm_type = resource.scorm_type
    	   	 lo.href = resource.href
    	   	 lo.scorm_file = self
           lo.metadata = YAML.dump(resource.metadata)
    	   	 lo.save
    	   end
    	end
      end
    end
  end
end