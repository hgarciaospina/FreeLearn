class AddAttachmentFileToScorms < ActiveRecord::Migration
  def self.up
    change_table :free_learn_scorms do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :free_learn_scorms, :file
  end
end
