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
    add_column :issues, :finished_on, :datetime
    add_column :issues, :error_on, :datetime
    add_column :issues, :execption_on, :datetime
    add_column :issues, :status_change_on, :datetime
  end

  def self.down
    remove_column :issues, :design_id
    remove_column :issues, :code
    remove_column :issues, :source
    remove_column :issues, :design_type
    remove_column :issues, :design_effect
    remove_column :issues, :style_effect
    remove_column :issues, :gallery_code
    remove_column :issues, :fee_code
    remove_column :issues, :task_type
    remove_column :issues, :task_status
    remove_column :issues, :created_source
    remove_column :issues, :finished_on
    remove_column :issues, :execption_on
    remove_column :issues, :status_change_on
  end
end
