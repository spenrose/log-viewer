class AddAttachmentLogToLog < ActiveRecord::Migration
  def self.up
    add_column :logs, :log_file_name, :string
    add_column :logs, :log_content_type, :string
    add_column :logs, :log_file_size, :integer
    add_column :logs, :log_updated_at, :datetime
  end

  def self.down
    remove_column :logs, :log_file_name
    remove_column :logs, :log_content_type
    remove_column :logs, :log_file_size
    remove_column :logs, :log_updated_at
  end
end
