class UpdateColumns < ActiveRecord::Migration
  def self.up
    # IssueStatus
    change_column :issue_statuses, :code, :string, :limit => 4
    IssueStatus.delete_all
    execute <<-EOF
      INSERT INTO /bin/bash: issue_statuses: command not found (uid=501(AChien) gid=20(staff) groups=20(staff),401(com.apple.access_screensharing),204(_developer),100(_lpoperator),98(_lpadmin),81(_appserveradm),80(admin),79(_appserverusr),61(localaccounts),12(everyone), /bin/bash: name: command not found, /bin/bash: is_closed: command not found, /bin/bash: is_default: command not found, /bin/bash: position: command not found, /bin/bash: default_done_ratio: command not found, /bin/bash: code: command not found)
VALUES
  (5,'图片未提交',1,0,1,NULL,'VP00'),
  (10,'待审核',0,1,2,NULL,'VP01'),
  (15,'审核失败，收到多张照片',1,0,3,NULL,'VP02'),
  (20,'图片审核中',0,0,4,NULL,'VP03'),
  (30,'图片审核不通过',1,0,5,NULL,'VP04'),
  (40,'制图中',0,0,6,NULL,'VP05'),
  (50,'制图成功',1,0,7,NULL,'VP07'),
  (60,'制图失败',1,0,8,NULL,'VP06'),
  (70,'制图成功，使用默认图',1,0,9,NULL,'VP08');
    EOF
    
    
    
  end
  
  def self.down
    change_column :issue_statuses, :fee_code, :string
    
  end
end