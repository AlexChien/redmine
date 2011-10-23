class AddIssueColumns < ActiveRecord::Migration
  def self.up
    add_column :issues, :design_id, :integer, :null => false
    add_column :issues, :code, :string, :null => false, :limit => 15
    add_column :issues, :approve_status, :string, :null => false, :limit => 2
    add_column :issues, :task_type, :string, :null => false, :limit => 2
    add_column :issues, :design_type, :string, :null => false, :limit => 2
    add_column :issues, :design_effect, :string, :null => false, :limit => 2
    add_column :issues, :style_effect, :string, :null => false, :limit => 2
    add_column :issues, :fee_code, :string, :null => false, :limit => 2
    add_column :issues, :tasked_at, :string, :null => false, :limit => 10
    add_column :issues, :source, :integer, :default => 0
  end

  def self.down
    remove_column  :issues, :design_id
    remove_column  :issues, :code
    remove_column  :issues, :approve_status
    remove_column  :issues, :task_type
    remove_column  :issues, :design_type
    remove_column  :issues, :design_effect
    remove_column  :issues, :style_effect
    remove_column  :issues, :fee_code
    remove_column  :issues, :tasked_at
  end
end
