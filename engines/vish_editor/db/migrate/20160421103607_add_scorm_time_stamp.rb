class AddScormTimeStamp < ActiveRecord::Migration
 def up
    add_column :free_learn_vish_editor_courses, :scorm_timestamp, :timestamp
  end

  def down
    remove_column :free_learn_vish_editor_courses, :scorm_timestamp
  end
end
