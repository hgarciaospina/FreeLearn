class AddUserToCourse < ActiveRecord::Migration
  def change
  	change_table :free_learn_vish_editor_courses do |t|
  		t.belongs_to :free_learn_user, index: true
  	end
  end
end
