class CreateGames < ActiveRecord::Migration
  def change
    create_table :free_learn_scorm_creator_games do |t|
      t.integer :game_template_id
      t.string :name
      t.string :description
      t.string :avatar_url
      t.timestamps
    end
  end
end
