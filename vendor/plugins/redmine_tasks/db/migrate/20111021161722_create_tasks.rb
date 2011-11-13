class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :code, :limit => 15, :null => false
      t.string :mobile, :limit => 11, :null => false
      t.string :birth, :limit => 4, :null => false
      t.string :source, :limit => 2     
      t.string :design_type, :limit => 2
      t.string :design_effect, :limit => 2
      t.string :style_effect, :limit => 1
      t.string :gallery_code, :limit => 2
      t.string :fee_code, :limit => 2
      t.string :file_name
      t.string :task_type, :limit => 1, :null => false
      t.integer :task_status, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
