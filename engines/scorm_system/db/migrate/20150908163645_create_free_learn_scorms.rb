class CreateFreeLearnScorms < ActiveRecord::Migration
  def change
    create_table :free_learn_scorms do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
