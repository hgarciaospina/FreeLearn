class CreateFreeLearnCourses < ActiveRecord::Migration
  def change
    create_table :free_learn_courses do |t|

      t.timestamps null: false
    end
  end
end
