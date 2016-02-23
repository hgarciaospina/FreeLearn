class MoveScormsHere < ActiveRecord::Migration
  def change
    create_table :free_learn_scorm_system_los do |t|
      t.integer :scorm_file_id
      t.string :lo_type
      t.string :scorm_type
      t.string :href
      t.string :metadata
      t.timestamps
    end
     create_table :free_learn_scorm_system_scorm_files do |t|
      t.string :name
      t.string :description
      t.string :avatar_url
      t.timestamps
    end
  end
end
