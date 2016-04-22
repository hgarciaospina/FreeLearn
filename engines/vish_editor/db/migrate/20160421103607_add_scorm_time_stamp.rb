class AddScormTimeStamp < ActiveRecord::Migration
 def up
    add_column :free_learn_vish_editor_courses, :scorm12_timestamp, :timestamp
    add_column :free_learn_vish_editor_courses, :scorm2004_timestamp, :timestamp
  end

  def down
    remove_column :free_learn_vish_editor_courses, :scorm12_timestamp
    remove_column :free_learn_vish_editor_courses, :scorm2004_timestamp
  end
end
