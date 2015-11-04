Deface::Override.new(:virtual_path => "layouts/free_learn/application",
                     :name => "add_scorm_link_to_nav",
                     :insert_after => "[data-freelearn-hook='main_nav']",
                     :partial => "overrides/scorm_link",
                     :namespaced => true,
                     :original => "21839ca5b21e8c560d4eecc4ab2ccc0caec37ddb" )
