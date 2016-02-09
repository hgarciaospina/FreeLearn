class CreateGameTemplateEvents < ActiveRecord::Migration
  def change
    create_table :free_learn_scorm_creator_game_template_events do |t|
      t.integer :game_template_id
      t.string :name
      t.string :description
      t.string :event_type
      t.integer :id_in_game
      t.timestamps
    end
  end
end
