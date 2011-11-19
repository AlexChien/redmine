class AddIssueColumns < ActiveRecord::Migration
  def self.up
    add_column :issues, :design_id, :integer
    add_column :issues, :code, :string, :limit => 15, :null => false
    add_column :issues, :source, :string, :limit => 2
    add_column :issues, :design_type, :string, :limit => 2
    add_column :issues, :design_effect, :string, :limit => 2
    add_column :issues, :style_effect, :string, :limit => 1
    add_column :issues, :gallery_code, :string, :limit => 2
    add_column :issues, :fee_code, :string, :limit => 2
    add_column :issues, :task_type, :string, :limit => 1, :null => false
    add_column :issues, :task_status, :integer, :default => 1
    add_column :issues, :created_source, :integer, :default => 0
  end

  def self.down
    remove_column  :issues, :design_id
    remove_column  :issues, :code
    remove_column  :issues, :source
    remove_column  :issues, :design_type
    remove_column  :issues, :design_effect
    remove_column  :issues, :style_effect
    remove_column  :issues, :gallery_code
    remove_column  :issues, :fee_code
    remove_column  :issues, :task_type
    remove_column  :issues, :task_status
    remove_column  :issues, :created_source
  end
end
