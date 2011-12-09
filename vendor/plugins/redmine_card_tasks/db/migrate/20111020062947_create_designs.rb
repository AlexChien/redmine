class CreateDesigns < ActiveRecord::Migration
  def self.up
    create_table :designs do |t|
      t.string :code,:limit=>2
      t.string :name
      t.integer :tracker_id
    end
  end

  def self.down
    drop_table :designs
  end
end
