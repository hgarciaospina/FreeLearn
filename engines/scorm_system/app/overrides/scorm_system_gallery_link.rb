Deface::Override.new(:virtual_path => "layouts/free_learn/application",
                     :name => "add_scorm_gallery_link_to_nav",
                     :insert_after => "[data-freelearn-hook='main_nav']",
                     :partial => "overrides/scorm_system_gallery",
                     :namespaced => true )