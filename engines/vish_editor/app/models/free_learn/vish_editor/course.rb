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

    def self.zip_folder(zipFilePath,root,dir=nil)
      dir = root unless dir

      folderNames = []
      fileNames = []

      Dir.entries(dir).reject{|i| i.start_with?(".")}.each do |itemName|
        itemPath = "#{dir}/#{itemName}"
        if File.directory?(itemPath)
          folderNames << itemName
        elsif File.file?(itemPath)
          fileNames << itemName
        end
      end

    folderNames.each do |subFolderName|
      zip_folder(zipFilePath,root,"#{dir}/#{subFolderName}")
    end

    #Files
    if fileNames.length > 0
      Zip::File.open(zipFilePath, Zip::File::CREATE) { |zipfile|
        fileNames.each do |fileName|
          filePathInZip = String.new("#{dir}/#{fileName}").sub(root + "/","")
          zipfile.add(filePathInZip,"#{dir}/#{fileName}")
        end
      }
    end

    end

    def user
      FreeLearn::User.find(self.free_learn_user_id)
    end

    ####################
    # SCORM MANAGEMENT #
    ####################

    def scormFilePath(version)
      Course.scormFolderPath(version) + "#{self.id}.zip"
    end

    def self.scormFolderPath(version)
      return "#{Rails.root}/public/scorm/" + version + "/courses/"
    end

    def to_scorm(controller,version="2004")
      if self.scorm_needs_generate(version)
        folderPath = Course.scormFolderPath(version)
        fileName = self.id
        json = JSON(self.json)
        Course.createSCORM(version,folderPath,fileName,json,self,controller)
        self.update_column(((version=="12") ? :scorm12_timestamp : :scorm2004_timestamp), Time.now)
        return "#{folderPath}#{fileName}.zip"
      else
        return Course.scormFolderPath(version)+self.id.to_s+".zip"
      end

    end

    def scorm_needs_generate(version="2004")
      scormTimestam = (version=="12") ? self.scorm12_timestamp : self.scorm2004_timestamp
      scormTimestam.nil? or self.updated_at > scormTimestam or !File.exist?(self.scormFilePath(version))
    end


    def remove_scorm
      if File.exist?("#{Rails.root}/public/scorm/courses/#{self.id}.zip")
        File.delete("#{Rails.root}/public/scorm/courses/#{self.id}.zip")
      end
    end

    def self.createSCORM(version="2004",folderPath,fileName,json,excursion,controller)
      require 'zip'

      # folderPath = "#{Rails.root}/public/scorm/version/excursions/"
      # fileName = self.id
      # json = JSON(self.json)
      t = File.open("#{folderPath}#{fileName}.zip", 'w')

      #Add manifest, main HTML file and additional files
      Zip::OutputStream.open(t.path) do |zos|
        xml_manifest = self.generate_scorm_manifest(version,json,excursion)
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
      dir = "#{FreeLearn::VishEditor::Engine.root.to_s}/app/scorm"
      zip_folder(t.path,dir)

      #Add theme
      themesPath = "#{FreeLearn::VishEditor::Engine.root.to_s}/app/assets/images/themes/"
      theme = "theme1" #Default theme
      if json["theme"] and File.exists?(themesPath + json["theme"])
        theme = json["theme"]
      end
      #Copy excursion theme
      zip_folder(t.path,"#{FreeLearn::VishEditor::Engine.root.to_s}/app/assets",themesPath + theme)

      t.close
    end




    def self.generate_scorm_manifest(version,ejson,course,options={})
      version = "2004" unless version.is_a? String and ["12","2004"].include?(version)

      #Get manifest resource identifier and LOM identifier
      if course and !course.id.nil?
        identifier = course.id.to_s
        lomIdentifier = FreeLearn::Core::Engine.routes.url_helpers.course_url(course.id)
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

      myxml = ::Builder::XmlMarkup.new(:indent => 2)
      myxml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"


       #Select LOM Header options
      manifestHeaderOptions = {}
      manifestContent = {}

      case version
      when "12"
        #SCORM 1.2
        manifestHeaderOptions = {
          "identifier"=>"VISH_PRESENTATION_" + identifier,
          "version"=>"1.0",
          "xmlns"=>"http://www.imsproject.org/xsd/imscp_rootv1p1p2",
          "xmlns:adlcp"=>"http://www.adlnet.org/xsd/adlcp_rootv1p2",
          "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
          "xsi:schemaLocation"=>"http://www.imsproject.org/xsd/imscp_rootv1p1p2 imscp_rootv1p1p2.xsd http://www.imsglobal.org/xsd/imsmd_rootv1p2p1 imsmd_rootv1p2p1.xsd http://www.adlnet.org/xsd/adlcp_rootv1p2 adlcp_rootv1p2.xsd"
        }
        manifestContent["schemaVersion"] = "1.2"
      when "2004"
        #SCORM 2004 4th Edition
        manifestHeaderOptions =  {
          "identifier"=>"VISH_PRESENTATION_" + identifier,
          "version"=>"1.3",
          "xmlns"=>"http://www.imsglobal.org/xsd/imscp_v1p1",
          "xmlns:adlcp"=>"http://www.adlnet.org/xsd/adlcp_v1p3",
          "xmlns:adlseq"=>"http://www.adlnet.org/xsd/adlseq_v1p3",
          "xmlns:adlnav"=>"http://www.adlnet.org/xsd/adlnav_v1p3",
          "xmlns:imsss"=>"http://www.imsglobal.org/xsd/imsss",
          "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
          "xsi:schemaLocation"=>"http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd http://www.adlnet.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd"
        }
        manifestContent["schemaVersion"] = "2004 4th Edition"
      else
        #Future SCORM versions
      end

      myxml.manifest(manifestHeaderOptions) do

        myxml.metadata do
          myxml.schema("ADL SCORM")
          myxml.schemaversion(manifestContent["schemaVersion"])
          #Add LOM metadata
          Course.generate_LOM_metadata(ejson,course,{:target => myxml, :id => lomIdentifier, :LOMschema => (options[:LOMschema]) ? options[:LOMschema] : "custom", :scormVersion => version})
        end

        myxml.organizations('default'=>"defaultOrganization") do
          myxml.organization('identifier'=>"defaultOrganization") do
            if ejson["title"]
              myxml.title(ejson["title"])
            else
              myxml.title("Untitled")
            end
            itemOptions = {
              'identifier'=>"PRESENTATION_" + identifier,
              'identifierref'=>"PRESENTATION_" + identifier + "_RESOURCE"
            }
            if version == "12"
              itemOptions["isvisible"] = "true"
            end
            myxml.item(itemOptions) do
              if ejson["title"]
                myxml.title(ejson["title"])
              else
                myxml.title("Untitled")
              end
              if version == "12"
                myxml.tag!("adlcp:masteryscore") do
                  myxml.text!("50")
                end
              end
            end
          end
        end

        resourceOptions = {
          'identifier'=>"PRESENTATION_" + identifier + "_RESOURCE",
          'type'=>"webcontent",
          'href'=>"excursion.html",
        }
        if version == "12"
          resourceOptions['adlcp:scormtype'] = "sco"
        else
          resourceOptions['adlcp:scormType'] = "sco"
        end

        myxml.resources do
          myxml.resource(resourceOptions) do
            myxml.file('href'=> "excursion.html")
          end
        end

      end

      return myxml
    end

    ####################
    ## LOM Metadata
    ####################

  def self.readableContext(context, _LOMschema)
    case _LOMschema
    when "ODS"
      #ODS LOM Extension
      #According to ODS, context has to be one of ["primary education", "secondary education", "informal context"]
      case context
      when "preschool", "pEducation", "primary education", "school"
        return "primary education"
      when "sEducation", "higher education", "university"
        return "secondary education"
      when "training", "other"
        return "informal context"
      else
        return nil
      end
    when "ViSH"
      #ViSH LOM extension
      case context
      when "unspecified"
        return "Unspecified"
      when "preschool"
        return "Preschool Education"
      when "pEducation"
        return "Primary Education"
      when "sEducation"
        return "Secondary Education"
      when "higher education"
        return "Higher Education"
      when "training"
        return "Professional Training"
      when "other"
        return "Other"
      else
        return context
      end
    else
      #Strict LOM mode. Extensions are not allowed
      case context
      when "unspecified"
        return nil
      when "preschool"
      when "pEducation"
      when "sEducation"
        return "school"
      when "higher education"
        return "higher education"
      when "training"
        return "training"
      else
        return "other"
      end
    end
  end

  def self.getLearningResourceType(lreType, _LOMschema)
    case _LOMschema
    when "ODS"
      #ODS LOM Extension
      #According to ODS, the Learning REsources type has to be one of this:
      allowedLREtypes = ["application","assessment","blog","broadcast","case study","courses","demonstration","drill and practice","educational game","educational scenario","learning scenario","pedagogical scenario","enquiry-oriented activity","exercise","experiment","glossaries","guide","learning pathways","lecture","lesson plan","open activity","other","presentation","project","reference","role play","simulation","social media","textbook","tool","website","wiki","audio","data","image","text","video"]
    else
      allowedLREtypes = ["exercise","simulation","questionnaire","diagram","figure","graph","index","slide","table","narrative text","exam","experiment","problem statement","self assessment","lecture"]
    end

    if allowedLREtypes.include? lreType
      return lreType
    else
      return nil
    end
  end

  def self.generateVCard(fullName)
    return "BEGIN:VCARD&#xD;VERSION:3.0&#xD;N:"+fullName+"&#xD;FN:"+fullName+"&#xD;END:VCARD"
  end

  def self.getLOMLoLanguage(language, _LOMschema)
    #List of language codes according to ISO-639:1988
    # lanCodes = ["aa","ab","af","am","ar","as","ay","az","ba","be","bg","bh","bi","bn","bo","br","ca","co","cs","cy","da","de","dz","el","en","eo","es","et","eu","fa","fi","fj","fo","fr","fy","ga","gd","gl","gn","gu","gv","ha","he","hi","hr","hu","hy","ia","id","ie","ik","is","it","iu","ja","jw","ka","kk","kl","km","kn","ko","ks","ku","kw","ky","la","lb","ln","lo","lt","lv","mg","mi","mk","ml","mn","mo","mr","ms","mt","my","na","ne","nl","no","oc","om","or","pa","pl","ps","pt","qu","rm","rn","ro","ru","rw","sa","sd","se","sg","sh","si","sk","sl","sm","sn","so","sq","sr","ss","st","su","sv","sw","ta","te","tg","th","ti","tk","tl","tn","to","tr","ts","tt","tw","ug","uk","ur","uz","vi","vo","wo","xh","yi","yo","za","zh","zu"]
    lanCodesMin = I18n.available_locales.map{|i| i.to_s}
    lanCodesMin.concat(["it","pt"]).uniq!

    case _LOMschema
    when "ODS"
      #ODS requires language, and admits blank language.
      if language.nil? or language == "independent" or !lanCodesMin.include?(language)
        return "none"
      end
    else
      #When language=nil, no language attribute is provided
      if language.nil? or language == "independent" or !lanCodesMin.include?(language)
        return nil
      end
    end

    #It is included in the lanCodes array
    return language
  end



    # Metadata based on LOM (Learning Object Metadata) standard
    # LOM final draft: http://ltsc.ieee.org/wg12/files/LOM_1484_12_1_v1_Final_Draft.pdf

    def self.generate_LOM_metadata(ejson, course, options={})
      _LOMschema = "custom"

      supportedLOMSchemas = ["custom","loose","ODS","ViSH"]
      if supportedLOMSchemas.include? options[:LOMschema]
        _LOMschema = options[:LOMschema]
      end

      if options[:target]
        myxml = ::Builder::XmlMarkup.new(:indent => 2, :target => options[:target])
      else
        myxml = ::Builder::XmlMarkup.new(:indent => 2)
        myxml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      end

      #Select LOM Header options
      lomHeaderOptions = {}

      case _LOMschema
      when "loose","custom"
        lomHeaderOptions =  { 'xmlns' => "http://ltsc.ieee.org/xsd/LOM",
                              'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                              'xsi:schemaLocation' => "http://ltsc.ieee.org/xsd/LOM lom.xsd"
                            }
      when "ODS"
        lomHeaderOptions =  { 'xmlns' => "http://ltsc.ieee.org/xsd/LOM",
                              'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                              'xsi:schemaLocation' => "http://ltsc.ieee.org/xsd/LOM lomODS.xsd"
                            }
      else
        #Extension not supported/recognized
        lomHeaderOptions = {}
      end


      myxml.tag!("lom",lomHeaderOptions) do

        #Calculate some recurrent vars

        #Identifier
        loIdIsURI = false
        loIdIsURN = false
        loId = nil

        if options[:id]
            loId = options[:id].to_s

            begin
              loUri = URI.parse(loId)
              if %w( http https ).include?(loUri.scheme)
                loIdIsURI = true
              elsif %w( urn ).include?(loUri.scheme)
                loIdIsURN = true
              end
            rescue
            end

            if !loIdIsURI and !loIdIsURN
              #Build URN
              loId = "urn:ViSH:"+loId
            end
        end

        #Excursion instance
        courseInstance = nil
        if course
          courseInstance = course
        elsif ejson["vishMetadata"] and ejson["vishMetadata"]["id"]
          courseInstance = Course.find_by_id(ejson["vishMetadata"]["id"])
          courseInstance = nil unless courseInstance.public?
        end

        #Location
        loLocation = nil
        unless courseInstance.nil?
          loLocation =  FreeLearn::Core::Engine.routes.url_helpers.course_url(course.id)
        end

        #Language (LO language and metadata language)
        loLanguage = getLOMLoLanguage(ejson["language"], _LOMschema)
        if loLanguage.nil?
          loLanOpts = {}
        else
          loLanOpts = { :language=> loLanguage }
        end
        metadataLanguage = "en"

        #Author name
        authorName = nil
        if ejson["author"] and ejson["author"]["name"]
          authorName = ejson["author"]["name"]
        elsif (!course.nil? and !course.user.nil? and !course.user.email.nil?)
          authorName = course.user.email
        end

        # loDate
        # According to ISO 8601 (e.g. 2014-06-23)
        if course
          loDate = course.updated_at
        else
          loDate = Time.now
        end
        loDate = (loDate).strftime("%Y-%m-%d").to_s

        #VE version
        atVersion = ""
        if ejson["VEVersion"]
          atVersion = "v." + ejson["VEVersion"] + " "
        end
        atVersion = atVersion + "(http://github.com/ging/vish_editor)"


        #Building LOM XML

        myxml.general do

          if !loId.nil?
            myxml.identifier do
              if loIdIsURI
                myxml.catalog("URI")
              else
                myxml.catalog("URN")
              end
              myxml.entry(loId)
            end
          end

          myxml.title do
            if ejson["title"]
              myxml.string(ejson["title"], loLanOpts)
            else
              myxml.string("Untitled", :language=> metadataLanguage)
            end
          end

          if loLanguage
            myxml.language(loLanguage)
          end

          myxml.description do
            if ejson["description"]
              myxml.string(ejson["description"], loLanOpts)
            elsif ejson["title"]
              myxml.string(ejson["title"] + ". A Virtual Excursion provided by FreeLearn")
            else
              myxml.string("Virtual Excursion provided by FreeLearn")
            end
          end
          if ejson["tags"] && ejson["tags"].kind_of?(Array)
            ejson["tags"].each do |tag|
              myxml.keyword do
                myxml.string(tag.to_s, loLanOpts)
              end
            end
          end
          #Add subjects as additional keywords
          if ejson["subject"]
            if ejson["subject"].kind_of?(Array)
              ejson["subject"].each do |subject|
                myxml.keyword do
                  myxml.string(subject, loLanOpts)
                end
              end
            elsif ejson["subject"].kind_of?(String)
              myxml.keyword do
                  myxml.string(ejson["subject"], loLanOpts)
              end
            end
          end

          myxml.structure do
            myxml.source("LOMv1.0")
            myxml.value("hierarchical")
          end
          myxml.aggregationLevel do
            myxml.source("LOMv1.0")
            myxml.value("2")
          end
        end

        myxml.lifeCycle do
          myxml.version do
            myxml.string("v"+loDate.gsub("-","."), :language=>metadataLanguage)
          end
          myxml.status do
            myxml.source("LOMv1.0")
            if ejson["vishMetadata"] and ejson["vishMetadata"]["draft"]==="true"
              myxml.value("draft")
            else
              myxml.value("final")
            end
          end

          if !authorName.nil?
            myxml.contribute do
              myxml.role do
                myxml.source("LOMv1.0")
                myxml.value("author")
              end
              authorEntity = generateVCard(authorName)
              myxml.entity(authorEntity)

              myxml.date do
                myxml.dateTime(loDate)
                unless _LOMschema == "ODS"
                  myxml.description do
                    myxml.string("This date represents the date the author finished the indicated version of the Learning Object.", :language=> metadataLanguage)
                  end
                end
              end
            end
          end
          myxml.contribute do
            myxml.role do
              myxml.source("LOMv1.0")
              myxml.value("technical implementer")
            end
            authoringToolName = "Authoring Tool ViSH Editor " + atVersion
            authoringToolEntity = generateVCard(authoringToolName)
            myxml.entity(authoringToolEntity)
          end
        end

        myxml.metaMetadata do
          unless courseInstance.nil?
            myxml.identifier do
              myxml.catalog("URI")
              myxml.entry( FreeLearn::Core::Engine.routes.url_helpers.course_url(course.id) + "/metadata.xml")
            end
          end
          unless authorName.nil?
            myxml.contribute do
              myxml.role do
                myxml.source("LOMv1.0")
                myxml.value("creator")
              end
              myxml.entity(generateVCard(authorName))
              myxml.date do
                myxml.dateTime(loDate)
                unless _LOMschema == "ODS"
                  myxml.description do
                    myxml.string("This date represents the date the author finished authoring the metadata of the indicated version of the Learning Object.", :language=> metadataLanguage)
                  end
                end
              end

            end
          end
          myxml.metadataSchema("LOMv1.0")
          myxml.language(metadataLanguage)
        end

        myxml.technical do
          myxml.format("text/html")
          if !loLocation.nil?
            myxml.location(loLocation)
          end
          myxml.requirement do
            myxml.orComposite do
              myxml.type do
                myxml.source("LOMv1.0")
                myxml.value("browser")
              end
              myxml.name do
                myxml.source("LOMv1.0")
                myxml.value("any")
              end
            end
          end
          myxml.installationRemarks do
            myxml.string("Unzip the zip file and launch excursion.html in your browser.", :language=> metadataLanguage)
          end
          myxml.otherPlatformRequirements do
            otherPlatformRequirements = "HTML5-compliant web browser"
            if ejson["VEVersion"]
              otherPlatformRequirements += " and ViSH Viewer " + atVersion
            end
            otherPlatformRequirements += "."
            myxml.string(otherPlatformRequirements, :language=> metadataLanguage)
          end
        end

        myxml.educational do
          myxml.interactivityType do
            myxml.source("LOMv1.0")
            myxml.value("mixed")
          end

          if !getLearningResourceType("lecture", _LOMschema).nil?
            myxml.learningResourceType do
              myxml.source("LOMv1.0")
              myxml.value("lecture")
            end
          end
          if !getLearningResourceType("presentation", _LOMschema).nil?
            myxml.learningResourceType do
              myxml.source("LOMv1.0")
              myxml.value("presentation")
            end
          end
          if !getLearningResourceType("slide", _LOMschema).nil?
            myxml.learningResourceType do
              myxml.source("LOMv1.0")
              myxml.value("slide")
            end
          end
          presentationElements = VishEditorUtils.getElementTypes(ejson) rescue []
          if presentationElements.include?("text") and !getLearningResourceType("narrative text", _LOMschema).nil?
            myxml.learningResourceType do
              myxml.source("LOMv1.0")
              myxml.value("narrative text")
            end
          end
          if presentationElements.include?("quiz") and !getLearningResourceType("questionnaire", _LOMschema).nil?
            myxml.learningResourceType do
              myxml.source("LOMv1.0")
              myxml.value("questionnaire")
            end
          end
          myxml.interactivityLevel do
            myxml.source("LOMv1.0")
            myxml.value("very high")
          end
          myxml.intendedEndUserRole do
            myxml.source("LOMv1.0")
            myxml.value("learner")
          end
          _LOMcontext = readableContext(ejson["context"], _LOMschema)
          if _LOMcontext
            myxml.context do
              myxml.source("LOMv1.0")
              myxml.value(_LOMcontext)
            end
          end
          if ejson["age_range"]
            myxml.typicalAgeRange do
              myxml.string(ejson["age_range"], :language=> metadataLanguage)
            end
          end
          if ejson["difficulty"]
            myxml.difficulty do
              myxml.source("LOMv1.0")
              myxml.value(ejson["difficulty"])
            end
          end
          if ejson["TLT"]
            myxml.typicalLearningTime do
              myxml.duration(ejson["TLT"])
            end
          end
          if ejson["educational_objectives"]
            myxml.description do
              myxml.string(ejson["educational_objectives"], loLanOpts)
            end
          end
          if loLanguage
            myxml.language(loLanguage)
          end
        end

        myxml.rights do
          myxml.cost do
            myxml.source("LOMv1.0")
            myxml.value("no")
          end
          myxml.copyrightAndOtherRestrictions do
            myxml.source("LOMv1.0")
            myxml.value("yes")
          end
          myxml.description do
            license = ""
            unless ejson["license"].nil? or ejson["license"]["name"].blank?
              license = "License: '" + ejson["license"]["name"] + "'. "
            end
          end
        end


      end

      myxml
    end


  end
end
