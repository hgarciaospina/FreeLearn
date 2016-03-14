module FreeLearn
  module VishEditor
    class Engine < ::Rails::Engine
      isolate_namespace VishEditor

      paths["app/views"] << "app/views/free_learn/vish_editor"

    end
  
  end
end



