class CreateEventMappings < ActiveRecord::Migration
  def change
    create_table :free_learn_scorm_creator_event_mappings do |t|
      t.integer :game_template_event_id
      t.integer :game_id
      t.integer :lo_id
      t.timestamps
    end
  end
end
