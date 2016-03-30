class CreateFreeLearnVishEditorCourses < ActiveRecord::Migration
  def change
    create_table :free_learn_vish_editor_courses do |t|
      t.text :json
      t.timestamps null: false
    end
  end
end
