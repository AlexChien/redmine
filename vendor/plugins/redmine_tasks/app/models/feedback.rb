class Feedback
  OUTPUT = "#{Setting.spdcc_path}/sftp/output"
  OUTPUT_PICTURESTATUS = "#{Setting.spdcc_path}/sftp/output/picturestatus"
  OUTPUT_VPTOCS = "#{Setting.spdcc_path}/sftp/output/vptocs"
  OUTPUT_PICTURES = "#{Setting.spdcc_path}/sftp/output/pictures"
  OUTPUT_VPTOMKT = "#{Setting.spdcc_path}/sftp/output/vptomkt"
  
  # 终稿图片文件
  def self.final_image
    Attachment.in_final(1).in_output(0).all(:order=>"created_on ASC").each do |a|
      container = a.container
      if container.class == Issue
        FileUtils.copy("#{Attachment.storage_path}/#{a.disk_filename}","#{OUTPUT_PICTURES}/#{container.code}#{container.style_effect}.jpg")
        a.update_attribute(:output,1)
      end
    end
  end
  
  # 终稿图片文件 清单
  def self.final_file
    to = Date.today
    file = File.new("#{OUTPUT_PICTURES}/0310-SKTRSP-#{to.to_s.gsub('-','')}","w")
    Issue.in_status_code("VP07").in_finished_on(to).all.each do |i|
      file.write "#{i.code}           #{i.source}#{i.design_type}#{i.design_effect}  \n"
    end
    file.close
  end
  
  # 终稿图片文件 版式汇总清单
  def self.final_layout
    to = Date.today
    file = File.new("#{OUTPUT_VPTOMKT}/0310-SKTRSPLAYOUT-#{to.to_s.gsub('-','')}","w")
    file.write "1#{Issue.in_status_code('VP07').in_finished_on(to).in_style_effect(1).count}\n"
    file.write "2#{Issue.in_status_code('VP07').in_finished_on(to).in_style_effect(2).count}\n"
    file.close
  end
  
  # 制图失败工单报表
  def self.final_error
    to = Date.today
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "制图失败工单报表"
    concat = ["信息编码","Promotion ID","任务类型","状态信息","报告时间","工单等待时间","失败原因"]
    sheet.row(0).concat(concat)
    Issue.in_status_code(["VP00","VP04","VP06"]).in_error_on(to).all.each_with_index do |i,index|
      replace = []
      replace << i.code
      replace << ("#{i.source}#{i.design_type}#{i.design_effect}")
      replace << Issue::TASK_TYPES[i.task_type]
      replace << i.status.code
      replace << (i.error_on.to_s(:db))
      replace << wait_time(i.created_on)
      replace << i.description
      sheet.row(index+1).replace(replace)
    end
    file_name = "#{OUTPUT_VPTOCS}/0310-TASKFAILED-#{to.to_s.gsub('-','')}.xls"
    book.write(file_name)
  end
  
  # 制图异常工单报表
  def self.final_execption
    to = Date.today
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "制图异常工单报表"
    concat = ["信息编码","任务类型","状态信息","报告时间","工单等待时间"]
    sheet.row(0).concat(concat)
    Issue.in_status_code(["VP02"]).in_execption_on(to).all.each_with_index do |i,index|
      replace = []
      replace << i.code
      replace << Issue::TASK_TYPES[i.task_type]
      replace << i.status.code
      replace << (i.execption_on.to_s(:db))
      replace << wait_time(i.created_on)
      sheet.row(index+1).replace(replace)
    end
    file_name = "#{OUTPUT_VPTOCS}/0310-TASKEXCEPTION-#{to.to_s.gsub('-','')}.xls"
    book.write(file_name)
  end
  
  # 卡片获批可制图工单任务状态更新文件
  def self.final_status_change
    to = Date.today
    file = File.new("#{OUTPUT_PICTURESTATUS}/0310-TASKSTATUS-#{to.to_s.gsub('-','')}","w")
    Issue.in_status_change_on(to).all.each do |i|
      file.write "#{i.code}#{i.status.code}#{i.description}\n"
    end
    file.close
  end

protected
  def self.wait_time(created_on)
    days = (Date.today - created_on.to_date).to_i + 1
    days = 99 if days > 99
    '%02d' % days
  end
end