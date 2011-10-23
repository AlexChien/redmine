class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :code, :null => false, :limit => 15
      t.string :mobile, :null => false, :limit => 11
      t.string :birth, :null => false, :limit => 4
      t.string :approve_status, :null => false, :limit => 2
      t.string :task_type, :null => false, :limit => 2
      t.string :design_type, :null => false, :limit => 2
      t.string :design_effect, :null => false, :limit => 2
      t.string :style_effect, :null => false, :limit => 2
      t.string :fee_code, :null => false, :limit => 2
      t.string :tasked_at, :null => false, :limit => 10
      t.string :file_name, :null => false
    end
  end

  def self.down
    drop_table :tasks
  end
end
