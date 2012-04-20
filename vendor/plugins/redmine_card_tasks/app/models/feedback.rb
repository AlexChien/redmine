class Feedback
  OUTPUT = "#{Setting.spdcc_path}/sftp/output"
  OUTPUT_PICTURESTATUS = "#{Setting.spdcc_path}/sftp/output/picturestatus"
  OUTPUT_VPTOCS = "#{Setting.spdcc_path}/sftp/output/vptocs"
  OUTPUT_PICTURES = "#{Setting.spdcc_path}/sftp/output/pictures"
  OUTPUT_VPTOMKT = "#{Setting.spdcc_path}/sftp/output/vptomkt"
  
  OUTPUT_BK = "#{Setting.spdcc_path}/output_bk"
  OUTPUT_BK_PICTURESTATUS = "#{Setting.spdcc_path}/output_bk/picturestatus"
  OUTPUT_BK_VPTOCS = "#{Setting.spdcc_path}/output_bk/vptocs"
  OUTPUT_BK_PICTURES = "#{Setting.spdcc_path}/output_bk/pictures"
  OUTPUT_BK_VPTOMKT = "#{Setting.spdcc_path}/output_bk/vptomkt"
  
  # 终稿图片文件
  def self.final_image
    attachment_ids = Attachment.in_issue_status([50,70]).in_final(1).in_output(0).collect(&:id)
    Attachment.in_ids(attachment_ids).all(:order=>"attachments.created_on ASC").each do |a|
      container = a.container
      if container.class == Issue
        file_name = "#{container.code}#{container.style_effect}.jpg"
        FileUtils.copy("#{Attachment.storage_path}/#{a.disk_filename}","#{OUTPUT_PICTURES}/#{file_name}")
        FileUtils.copy("#{OUTPUT_PICTURES}/#{file_name}","#{OUTPUT_BK_PICTURES}/#{file_name}")
        a.update_attribute(:output,1)
      end
    end
  end
  
  # 终稿图片文件 清单
  def self.final_file
    to = Date.today
    file_name = "0310-SKTRSP-#{to.to_s.gsub('-','')}"
    file = File.new("#{OUTPUT_PICTURES}/#{file_name}","w")
    Issue.in_status_code(["VP07","VP08"]).in_finished_on(to).all.each do |i|
      file.write "#{i.code}           #{i.promotion_id}  \r\n"
    end
    file.close
    FileUtils.copy("#{OUTPUT_PICTURES}/#{file_name}","#{OUTPUT_BK_PICTURES}/#{file_name}")
  end
  
  # 终稿图片文件 版式汇总清单
  def self.final_layout
    to = Date.today
    file_name = "0310-SKTRSPLAYOUT-#{to.to_s.gsub('-','')}"
    file = File.new("#{OUTPUT_VPTOMKT}/#{file_name}","w")
    file.write "0#{Issue.in_status_code('VP08').in_finished_on(to).in_style_effect(0).count}\r\n"
    file.write "1#{Issue.in_status_code('VP07').in_finished_on(to).in_style_effect(1).count}\r\n"
    file.write "2#{Issue.in_status_code('VP07').in_finished_on(to).in_style_effect(2).count}\r\n"
    file.write "3#{Issue.in_status_code('VP07').in_finished_on(to).in_style_effect(3).count}\r\n"
    file.write "4#{Issue.in_status_code('VP07').in_finished_on(to).in_style_effect(4).count}\r\n"
    file.close
    FileUtils.copy("#{OUTPUT_VPTOMKT}/#{file_name}","#{OUTPUT_BK_VPTOMKT}/#{file_name}")
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
      replace << i.promotion_id
      replace << Issue::TASK_TYPES[i.task_type]
      replace << i.status.code
      replace << (i.error_on.to_s(:db))
      replace << wait_time(i.created_on)
      replace << i.description
      sheet.row(index+1).replace(replace)
    end
    file_name = "0310-TASKFAILED-#{to.to_s.gsub('-','')}.xls"
    file_path = "#{OUTPUT_VPTOCS}/#{file_name}"
    book.write(file_path)
    FileUtils.copy("#{OUTPUT_VPTOCS}/#{file_name}","#{OUTPUT_BK_VPTOCS}/#{file_name}")
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
    file_name = "0310-TASKEXCEPTION-#{to.to_s.gsub('-','')}.xls"
    file_path = "#{OUTPUT_VPTOCS}/#{file_name}"
    book.write(file_path)
    FileUtils.copy("#{OUTPUT_VPTOCS}/#{file_name}","#{OUTPUT_BK_VPTOCS}/#{file_name}")
  end
  
  # 卡片获批可制图工单任务状态更新文件
  def self.final_status_change
    to = Date.today
    file_name = "0310-TASKSTATUS-#{to.to_s.gsub('-','')}"
    file = File.new("#{OUTPUT_PICTURESTATUS}/#{file_name}","w")
    Issue.in_status_change_on(to).all.each do |i|
      file.write "#{i.code}#{i.status.code}#{i.description}\r\n"
    end
    file.close
    FileUtils.copy("#{OUTPUT_PICTURESTATUS}/#{file_name}","#{OUTPUT_BK_PICTURESTATUS}/#{file_name}")
  end
  
  # 创建技术文档parse_log,parse_error_log
  def self.document_parse_log
    d = Document.find_by_title("parse_log")
    unless d
      d = Document.create(:project=>Project.first,
                          :category_id=>2,
                          :title=>"parse_log",
                          :description=>"卡片获批可制图工单文件->解析日志")
    end

    file_name = "parse.log"
    d.attachments.destroy_all
    if File.exist?("#{RAILS_ROOT}/log/#{file_name}")
      attachment = Attachment.new(:author=>User.find(1),
                                  :container=>d,
                                  :filename=>file_name,
                                  :disk_filename=>Attachment.disk_filename(file_name),
                                  :content_type=>Redmine::MimeType.of(file_name),
                                  :filesize=>File.size("#{RAILS_ROOT}/log/#{file_name}"),
                                  :created_source=>1)
      FileUtils.copy("#{RAILS_ROOT}/log/#{file_name}","#{Attachment.storage_path}/#{Attachment.disk_filename(file_name)}")
      attachment.save
    end

    d2 = Document.find_by_title("parse_error_log")
    unless d2
      d2 = Document.create(:project=>Project.first,
                            :category_id=>2,
                            :title=>"parse_error_log",
                            :description=>"卡片获批可制图工单文件->解析错误日志")
    end

    file_name = "parse_error.log"
    d2.attachments.destroy_all
    if File.exist?("#{RAILS_ROOT}/log/#{file_name}")
      attachment = Attachment.new(:author=>User.find(1),
                                  :container=>d2,
                                  :filename=>file_name,
                                  :disk_filename=>Attachment.disk_filename(file_name),
                                  :content_type=>Redmine::MimeType.of(file_name),
                                  :filesize=>File.size("#{RAILS_ROOT}/log/#{file_name}"),
                                  :created_source=>1)
      FileUtils.copy("#{RAILS_ROOT}/log/#{file_name}","#{Attachment.storage_path}/#{Attachment.disk_filename(file_name)}")
      attachment.save
    end
  end

protected
  def self.wait_time(created_on)
    days = (Date.today - created_on.to_date).to_i + 1
    days = 99 if days > 99
    '%02d' % days
  end
end