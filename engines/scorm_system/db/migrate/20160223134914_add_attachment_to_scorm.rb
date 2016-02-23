class AddAttachmentToScorm < ActiveRecord::Migration
  def self.up
  	add_column :free_learn_scorm_system_scorm_files, :source_file_name, :string
	add_column :free_learn_scorm_system_scorm_files, :source_content_type, :string
	add_column :free_learn_scorm_system_scorm_files, :source_file_size, :integer
	add_column :free_learn_scorm_system_scorm_files, :source_updated_at,   :datetime
  end

  def self.down
	remove_column :free_learn_scorm_system_scorm_files, :source_file_name
	remove_column :free_learn_scorm_system_scorm_files, :source_content_type
	remove_column :free_learn_scorm_system_scorm_files, :source_file_size
	remove_column :free_learn_scorm_system_scorm_files, :source_updated_at
	end

end
