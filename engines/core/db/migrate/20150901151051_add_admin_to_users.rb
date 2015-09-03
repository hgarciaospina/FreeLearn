class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :free_learn_users, :admin, :boolean
  end
end
