class CreateFreeLearnVishEditorCourses < ActiveRecord::Migration
  def change
    create_table :free_learn_vish_editor_courses do |t|
		t.belongs_to :free_learn_user, index: true
		t.text :title
		t.text :description
		t.text :json
		t.boolean :published, default: false
		t.timestamps null: false
    end
  end
end
