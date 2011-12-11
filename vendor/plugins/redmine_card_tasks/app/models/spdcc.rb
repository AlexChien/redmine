require "logger"

class Spdcc
  @logger ||= Logger.new("#{RAILS_ROOT}/log/parse.log")
  
  INCOMING = "#{Setting.spdcc_path}/sftp/incoming"
  OUTPUT = "#{Setting.spdcc_path}/sftp/output"
  FAILED = "#{Setting.spdcc_path}/failed"
  SUCCESS = "#{Setting.spdcc_path}/success"
  OUTPUT_BK = "#{Setting.spdcc_path}/output_bk"
  
  def self.parse_task
    @logger.info "\n********** #{Time.now.to_s(:db)} parsing **********"
    begin
      check_dir
      check_files
      read_files
      read_images
    rescue => e
      print_error(e)
    end
    @logger.info "******************** parsed *********************\n"
  end
  
  def self.parse_image(f)
    @logger.info "#{Time.now.to_s(:db)} #{f}"
    code = f[0,15]
    @i = Issue.in_code(code).first
    @t = CardTask.in_code(code).in_task_type(["",0]).last #找到换卡换图任务
    read_image(@t,@i,0,1) if @i
  end
  
  def self.parse_file(f)
    @logger.info "#{Time.now.to_s(:db)} #{f}"
    if File.exist?("#{SUCCESS}/#{f}")
      print_error("this file has already be parsed")
      FileUtils.mv("#{INCOMING}/#{f}","#{FAILED}/#{f}")
    else
      file=File.open("#{INCOMING}/#{f}")
      file.readlines.each do |l|
        line = l.gsub("\n","")
        @logger.info "#{Time.now.to_s(:db)} #{line}"
        case line
        when /^\d{15} {11}( |0|1)$/
          code = line[0,15]
          mobile = line[0,11]
          birth = line[11,4]
          task_type = line[26,1]
          @i = Issue.in_code(code).first
          CardTask.transaction do
            @t = CardTask.new(:code=>code,
                              :mobile=>mobile,
                              :birth=>birth,
                              :task_type=>task_type)
            if @t.save
              if @i
                @i.task_type = task_type
              else
                @i = Issue.new(:project=>Project.first,
                              :subject=>code,
                              :priority=>IssuePriority.default,
                              :tracker=>Tracker.first,
                              :author=>User.find(1),
                              :code=>code,
                              :task_type=>task_type,
                              :created_source=>1)
              end
              
              if @i.save
                if @i.task_type == "1"
                  @j=Journal.create!(:journalized_id=>@i.id,:journalized_type=>"Issue",:user=>User.find(1))
                  JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"task_type",:value=>Issue::TASK_TYPES[@i.task_type])
                  attachment = @i.attachments.last
                  attachment.update_attributes(:final=>1,:output=>1) if attachment
                else
                  read_image(@t,@i,task_type)
                end
              else
                print_error(@i.errors.full_messages.join("\n"))
              end
            else
              print_error(@t.errors.full_messages.join("\n"))
            end
          end
        else
          print_error("format error")
        end
      end
      file.close
      FileUtils.mv("#{INCOMING}/#{f}","#{SUCCESS}/#{f}")
    end
  end
  
  def self.read_image(t,i,task_type,read_type=0)
    dirp = Dir.open(INCOMING)
    image_array = []
    for ff in dirp
      case ff
      when /^\./, /~$/, /\.o/
      when /^#{i.code}(\d| ){9}.jpg$/
        image_array << ff
      end
    end

    CardTask.transaction do
      old_status = i.status
      old_source = Issue::SOURCE[i.source]
      old_design_type = (i.tracker.nil? ? nil : i.tracker.name)
      old_design_effect = (i.design.nil? ? nil : i.design.name)
      old_style_effect = Issue::STYLE_EFFECT[i.style_effect]
      old_gallery_code = i.gallery_code
      old_assigned_to_id = i.assigned_to_id
      
      case image_array.size
      when 0
        t.update_attribute(:task_status,0) if t
        is = IssueStatus.find_by_code("VP00")
        i.update_attributes(:status=>is,
                            :task_status=>0) if is
      when 1
        image_name = image_array[0]
        source = image_name[15,2]
        design_type = image_name[17,2]
        design_effect = image_name[19,2]
        style_effect = image_name[21,1]
        gallery_code = image_name[22,2]
        file_name = image_name

        if t
          if t.update_attributes(:task_status=>3,
                                  :source=>source,
                                  :design_type=>design_type,
                                  :design_effect=>design_effect,
                                  :style_effect=>style_effect,
                                  :gallery_code=>gallery_code,
                                  :file_name=>file_name,
                                  :image_created_at=>Time.now)
          else
            print_error(t.errors.full_messages.join("\n"))
          end
        end

        is = IssueStatus.find_by_code("VP01")
        if is
          if i.update_attributes(:task_status=>3,
                                  :source=>(source=="" ? i.source : source),
                                  :tracker=>(design_type=="" ? i.tracker : Tracker.find_by_code(design_type)),
                                  :design_type=>(design_type=="" ? i.design_type : design_type),
                                  :design=>(design_effect=="" ? i.tracker : Design.find_by_code(design_effect)),
                                  :design_effect=>(design_effect=="" ? i.design_effect : design_effect),
                                  :style_effect=>(style_effect=="" ? i.style_effect : style_effect),
                                  :gallery_code=>(gallery_code=="" ? i.gallery_code : gallery_code))

            attachment = Attachment.new(:author=>User.find(1),
                                        :container=>i,
                                        :filename=>image_name,
                                        :disk_filename=>Attachment.disk_filename(image_name),
                                        :content_type=>Redmine::MimeType.of(image_name),
                                        :filesize=>File.size("#{INCOMING}/#{image_name}"),
                                        :created_source=>1)
            FileUtils.copy("#{INCOMING}/#{image_name}","#{Attachment.storage_path}/#{Attachment.disk_filename(image_name)}")
            mv_image(image_name)
            attachment.save
          else
            print_error(i.errors.full_messages.join("\n"))
          end
        end
      else
        t.update_attribute(:task_status,2) if t
        is = IssueStatus.find_by_code("VP02")
        i.update_attributes(:status=>is,
                            :task_status=>2) if is
      end
      
      if old_status == i.status && i.status == IssueStatus.find_by_code("VP02")
      else
        @j=Journal.create!(:journalized_id=>@i.id,:journalized_type=>"Issue",:user=>User.find(1))
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"task_type",:value=>Issue::TASK_TYPES[i.task_type]) if read_type == 0
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"status_id",:old_value=>old_status,:value=>i.status) if old_status != i.status
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"assigned_to_id",:value=>old_assigned_to_id,:value=>i.assigned_to_id) if old_assigned_to_id != i.assigned_to_id
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"source",:old_value=>old_source,:value=>Issue::SOURCE[i.source]) if !source.blank? && old_source != Issue::SOURCE[i.source]
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"design_type",:old_value=>old_design_type,:value=>i.tracker.name) if !design_type.blank? && old_design_type != i.tracker.name
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"design_effect",:old_value=>old_design_effect,:value=>i.design.name) if !design_effect.blank? && old_design_effect != i.design.name
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"style_effect",:old_value=>old_style_effect,:value=>Issue::STYLE_EFFECT[i.style_effect]) if !style_effect.blank? && old_style_effect != Issue::STYLE_EFFECT[i.style_effect]
        JournalDetail.create(:journal=>@j,:property=>"attr",:prop_key=>"gallery_code",:old_value=>old_gallery_code,:value=>i.gallery_code) if !gallery_code.blank? && old_gallery_code != i.gallery_code
        JournalDetail.create(:journal=>@j,:property=>"attachment",:prop_key=>attachment.id,:value=>attachment) if attachment
      end
    end
  end

protected
  def self.mv_image(image_name)
    if File.exist?("#{SUCCESS}/#{image_name}")
      for i in 1..100
        if File.exist?("#{SUCCESS}/#{i}_#{image_name}")
        else
          FileUtils.mv("#{INCOMING}/#{image_name}","#{SUCCESS}/#{i}_#{image_name}")
          break
        end
      end
    else
      FileUtils.mv("#{INCOMING}/#{image_name}","#{SUCCESS}/#{image_name}")
    end
  end

  def self.check_dir
    Dir.open(INCOMING)
    Dir.open(OUTPUT)
    Dir.open(FAILED)
    Dir.open(SUCCESS)
    Dir.open(OUTPUT_BK)
  end
  
  def self.check_files
    dirp = Dir.open(INCOMING)
    for f in dirp
      case f
      when /^\./, /~$/, /\.o/
      when /^0310-SKTWAIT-\d{8}$/
      when /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])(  |88|99)(  |\d{2})(  |\d{2})( |1|2)(  |\d{2}).jpg$/
      else
        mv_error_file(f)
      end
    end
  end
  
  def self.read_files
    dirp = Dir.open(INCOMING)
    #先处理文件，再处理图片
    for f in dirp
      case f
      when /^\./, /~$/, /\.o/
      when /^0310-SKTWAIT-\d{8}$/
        # 处理卡片获批可制图工单文件
        parse_file(f)
      when /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])(  |88|99)(  |\d{2})(  |\d{2})( |1|2)(  |\d{2}).jpg$/
      else
        mv_error_file(f)
      end
    end
  end
  
  def self.read_images
    dirp = Dir.open(INCOMING)
    #先处理文件，再处理图片
    for f in dirp
      case f
      when /^\./, /~$/, /\.o/
      when /^0310-SKTWAIT-\d{8}$/  
      when /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])(  |88|99)(  |\d{2})(  |\d{2})( |1|2)(  |\d{2}).jpg$/
        parse_image(f)
      else
        mv_error_file(f)
      end
    end
  end
  
  def self.mv_error_file(f)
    # 处理不可识别文件
    @logger.error "#{Time.now.to_s(:db)} #{f}"
    print_error("filename error")
    FileUtils.mv("#{INCOMING}/#{f}","#{FAILED}/#{f}")
  end
  
  def self.print_error(e)
    @logger.error ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    @logger.error e
    @logger.error ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end
end