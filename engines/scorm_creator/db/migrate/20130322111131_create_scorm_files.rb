class CreateScormFiles < ActiveRecord::Migration
  def change
    create_table :free_learn_scorm_creator_scorm_files do |t|
      t.string :name
      t.string :description
      t.string :avatar_url
      t.timestamps
    end
  end
end
