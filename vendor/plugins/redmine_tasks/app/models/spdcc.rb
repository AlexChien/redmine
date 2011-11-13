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
      dirp = Dir.open(INCOMING)
      for f in dirp
        case f
        when /^\./, /~$/, /\.o/
        when /^\d{15}(\d| ){9}.jpg$/
          # 制图图片文件
          # parse_image(f)
        when /^0310-SKTWAIT-\d{8}$/
          # 处理卡片获批可制图工单文件
          parse_file(f)
        else
          # 处理不可识别文件
          @logger.error "#{Time.now.to_s(:db)} #{f}"
          print_error("filename error")
          FileUtils.mv("#{INCOMING}/#{f}","#{FAILED}/#{f}")
        end
      end
    rescue => e
      print_error(e)
    end
    @logger.info "******************** parsed *********************\n"
  end
  
  def self.parse_image(f)
    @logger.info "#{Time.now.to_s(:db)} #{f}"
    code = f[0,15]
    mobile = f[0,11]
    birth = f[11,4]
    source = f[15,2]
    design_type = f[17,2]
    design_effect = f[19,2]
    style_effect = f[21,1]
    gallery_code = f[22,2]
    file_name = f
    Task.transaction do
      t = Task.new(:code=>code,
                  :mobile=>mobile,
                  :birth=>birth,
                  :source=>source,
                  :design_type=>design_type,
                  :design_effect=>design_effect,
                  :style_effect=>style_effect,
                  :gallery_code=>gallery_code,
                  :file_name=>file_name)
      if t.save
        i = Issue.in_code(t.code).first
        if i

        else
          i = Issue.new(:tracker=>Tracker.in_code(t.design_type).first,
                        :project=>Project.first,
                        :subject=>t.code,
                        :priority=>IssuePriority.default,
                        :status=>IssueStatus.in_code(t.task_type).first,
                        :design=>Design.in_code(t.design_effect).first,
                        :author=>User.find(1),
                        :code=>t.code,
                        :source=>source,
                        :design_type=>design_type,
                        :design_effect=>design_effect,
                        :style_effect=>style_effect,
                        :gallery_code=>gallery_code,
                        :created_source=>1)
          if i.save!
            if t.file_name.match(/\.jpg$/)
              attachment = Attachment.new(:author=>User.find(1),
                                          :container=>i,
                                          :filename=>t.file_name,
                                          :disk_filename=>Attachment.disk_filename(t.file_name),
                                          :content_type=>Redmine::MimeType.of(t.file_name),
                                          :filesize=>File.size("#{INCOMING}/#{t.file_name}"))
              FileUtils.copy("#{INCOMING}/#{t.file_name}","#{Attachment.storage_path}/#{Attachment.disk_filename(t.file_name)}")
              attachment.save!
            end
          else
            print_error(i.errors.full_messages.join("\n"))
          end
        end
      else
        print_error(t.errors.full_messages.join("\n"))
      end
    end
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
        when /^\d{15} {11}( |1|2)$/
          code = line[0,15]
          mobile = line[0,11]
          birth = line[11,4]
          task_type = line[26,1]
          @i = Issue.in_code(code).first
          if @i
          else
            Task.transaction do
              @t = Task.new(:code=>code,
                           :mobile=>mobile,
                           :birth=>birth,
                           :task_type=>" ")
              if @t.save
                @i = Issue.new(:project=>Project.first,
                              :subject=>code,
                              :priority=>IssuePriority.default,
                              :tracker=>Tracker.first,
                              :author=>User.find(1),
                              :code=>code,
                              :task_type=>" ",
                              :created_source=>1)
                if @i.save
                else
                  print_error(@i.errors.full_messages.join("\n"))
                end
              else
                print_error(@t.errors.full_messages.join("\n"))
              end
            end
            
            dirp = Dir.open(INCOMING)
            image_array = []
            for ff in dirp
              case ff
              when /^\./, /~$/, /\.o/
              when /^#{code}(\d| ){9}.jpg$/
                image_array << ff
              end
            end

            Task.transaction do
              case image_array.size
              when 0
                @t.update_attribute(:task_status,0)
                is = IssueStatus.find_by_code("VP00")
                @i.update_attribute(:status,is) if is
              when 1
                image_name = image_array[0]
                source = image_name[15,2]
                design_type = image_name[17,2]
                design_effect = image_name[19,2]
                style_effect = image_name[21,1]
                gallery_code = image_name[22,2]
                file_name = image_name
                
                if @t.update_attributes(:task_status=>1,
                                        :source=>source,
                                        :design_type=>design_type,
                                        :design_effect=>design_effect,
                                        :style_effect=>design_type,
                                        :gallery_code=>gallery_code,
                                        :file_name=>file_name)
                else
                  print_error(@t.errors.full_messages.join("\n"))
                end
                
                is = IssueStatus.find_by_code("VP01")
                if is
                  if @i.update_attributes(:status=>is,
                                          :source=>source,
                                          :tracker=>Tracker.find_by_code(design_type),
                                          :design_type=>design_type,
                                          :design=>Design.find_by_code(design_effect),
                                          :design_effect=>design_effect,
                                          :style_effect=>design_type,
                                          :gallery_code=>gallery_code)
                     
                    attachment = Attachment.new(:author=>User.find(1),
                                                :container=>@i,
                                                :filename=>image_name,
                                                :disk_filename=>Attachment.disk_filename(image_name),
                                                :content_type=>Redmine::MimeType.of(image_name),
                                                :filesize=>File.size("#{INCOMING}/#{image_name}"))
                    FileUtils.copy("#{INCOMING}/#{image_name}","#{Attachment.storage_path}/#{Attachment.disk_filename(image_name)}")
                    FileUtils.mv("#{INCOMING}/#{image_name}","#{SUCCESS}/#{image_name}")
                    attachment.save
                  else
                    print_error(@i.errors.full_messages.join("\n"))
                  end
                end
              else
                @t.update_attribute(:task_status,2)
                is = IssueStatus.find_by_code("VP02")
                @i.update_attribute(:status,is) if is
              end
            end
          end
        else
          print_error("format error")
        end
      end
      file.close
    end
  end

protected
  def self.check_dir
    Dir.open(INCOMING)
    Dir.open(OUTPUT)
    Dir.open(FAILED)
    Dir.open(SUCCESS)
    Dir.open(OUTPUT_BK)
  end
  
  def self.print_error(e)
    @logger.error ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    @logger.error e
    @logger.error ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end
end