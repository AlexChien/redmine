class AddColumns < ActiveRecord::Migration
  def self.up
    add_column :trackers, :code, :string, :limit => 2
    add_column :issue_statuses, :code, :string, :limit => 2
    
    IssueStatus.all.each do |status|
      case status.name
      when "待审核"
        status.update_attribute(:code,"10")
      when "图片审核中"
        status.update_attribute(:code,"20")
      when "图片审核不通过"
        status.update_attribute(:code,"30")
      when "制图中"
        status.update_attribute(:code,"40")
      when "制图成功"
        status.update_attribute(:code,"50")
      when "制图失败"
        status.update_attribute(:code,"60")
      end
    end
    
    Tracker.all.each do |tracker|
      case tracker.name
      when "手绘Q图版"
        tracker.update_attribute(:code,"01")

        Design.create(:code=>"01",:name=>"卡通彩色",:tracker=>tracker)
        Design.create(:code=>"02",:name=>"卡通黑白",:tracker=>tracker)
        Design.create(:code=>"03",:name=>"写实彩色",:tracker=>tracker)
        Design.create(:code=>"04",:name=>"写实黑白",:tracker=>tracker)
      when "场景版"
        tracker.update_attribute(:code,"02")
        
        Design.create(:code=>"01",:name=>"场景1",:tracker=>tracker)
        Design.create(:code=>"02",:name=>"场景2",:tracker=>tracker)
      when "图库自选版"
        tracker.update_attribute(:code,"03")
        
        Design.create(:code=>"01",:name=>"图库1",:tracker=>tracker)
        Design.create(:code=>"02",:name=>"图库2",:tracker=>tracker)
      when "客户上传版"
        tracker.update_attribute(:code,"04")
        
        Design.create(:code=>"00",:name=>"客户图片",:tracker=>tracker)
      end
    end
  end

  def self.down
    remove_column :trackers, :code
    remove_column :issue_statuses, :code
  end
end
