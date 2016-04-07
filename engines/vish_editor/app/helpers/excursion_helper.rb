require 'builder'

module CourseHelper

    def generate_scorm_manifest(version,ejson,excursion,options={})
    version = "2004" unless version.is_a? String and ["12","2004"].include?(version)

    #Get manifest resource identifier and LOM identifier
    if excursion and !excursion.id.nil?
      identifier = excursion.id.to_s
      lomIdentifier = Rails.application.routes.url_helpers.excursion_url(:id => excursion.id)
    elsif (ejson["vishMetadata"] and ejson["vishMetadata"]["id"])
      identifier = ejson["vishMetadata"]["id"].to_s
      lomIdentifier = "urn:ViSH:" + identifier
    else
      count = Site.current.config["tmpCounter"].nil? ? 1 : Site.current.config["tmpCounter"]
      Site.current.config["tmpCounter"] = count + 1
      Site.current.save!

      identifier = "TmpSCORM_" + count.to_s
      lomIdentifier = "urn:ViSH:" + identifier

    end


    def translate_to_SCORM(version="2004",folderPath,fileName,json,excursion,controller)
      require 'zip'

      # folderPath = "#{Rails.root}/public/scorm/version/excursions/"
      # fileName = self.id
      # json = JSON(self.json)
      t = File.open("#{folderPath}#{fileName}.zip", 'w')

      #Add manifest, main HTML file and additional files
      Zip::OutputStream.open(t.path) do |zos|
        xml_manifest = generate_scorm_manifest(version,json,excursion)
        zos.put_next_entry("imsmanifest.xml")
        zos.print xml_manifest.target!()

        zos.put_next_entry("excursion.html")
        zos.print controller.render_to_string "show.scorm.erb", :locals => {:excursion=>excursion, :json => json}, :layout => false
      end

      #Add required XSD files and folders
      schemaDirs = []
      schemaFiles = []
      #SCORM schema
      schemaDirs.push("#{Rails.root}/public/schemas/SCORM_" + version)
      #LOM schema
      # schemaDirs.push("#{Rails.root}/public/schemas/lom")
      schemaFiles.push("#{Rails.root}/public/schemas/lom/lom.xsd");

      schemaDirs.each do |dir|
        zip_folder(t.path,dir)
      end

      if schemaFiles.length > 0
        Zip::File.open(t.path, Zip::File::CREATE) { |zipfile|
          schemaFiles.each do |filePath|
            zipfile.add(File.basename(filePath),filePath)
          end
        }
      end

      #Copy SCORM assets (image, javascript and css files)
      dir = "#{Rails.root}/lib/plugins/vish_editor/app/scorm"
      zip_folder(t.path,dir)

      #Add theme
      themesPath = "#{Rails.root}/lib/plugins/vish_editor/app/assets/images/themes/"
      theme = "theme1" #Default theme
      if json["theme"] and File.exists?(themesPath + json["theme"])
        theme = json["theme"]
      end
      #Copy excursion theme
      zip_folder(t.path,"#{Rails.root}/lib/plugins/vish_editor/app/assets",themesPath + theme)

      t.close

    end
end
