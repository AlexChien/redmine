class Task < ActiveRecord::Base
  unloadable
  
  validates_presence_of :code, :mobile, :birth, :approve_status, :task_type, :design_type,
                        :design_effect, :style_effect, :fee_code, :tasked_at, :file_name
  validates_uniqueness_of :file_name
  validates_format_of :code, :with => /^\d{15}$/
  validates_format_of :mobile, :with => /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}$/
  validates_format_of :birth, :with => /^(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/
  validates_format_of :approve_status, :with => /^10|20|30|40|50|60|70|80|90|99$/
  validates_format_of :task_type, :with => /^10|20|30|40$/
  validates_format_of :design_type, :with => /^\d{2}$/
  validates_format_of :design_effect, :with => /^\d{2}$/
  validates_format_of :style_effect, :with => /^00|01|02$/
  validates_format_of :fee_code, :with => /^01|02$/
  validates_format_of :tasked_at, :with => /^\d{10}$/
  validate :check_task_type, :check_design_type, :check_design_effect, :check_style_effect
  
  named_scope :in_code, lambda {|code|
    {:conditions => ["tasks.code in (?)", code]}
  }
  
  named_scope :in_task_type, lambda {|task_type|
    {:conditions => ["tasks.task_type in (?)", task_type]}
  }
  
  named_scope :not_in_design_type, lambda {|design_type|
    {:conditions => ["tasks.design_type not in (?)", design_type]}
  }

  INCOMING = "#{Setting.spdcc_path}/sftp/incoming"
  OUTPUT = "#{Setting.spdcc_path}/sftp/output"
  FAILED = "#{Setting.spdcc_path}/failed"
  SUCCESS = "#{Setting.spdcc_path}/success"
  OUTPUT_BK = "#{Setting.spdcc_path}/output_bk"

  def self.parse_task
    logger.info "******************** parsing ********************"
    begin
      check_dir
      dirp = Dir.open(INCOMING)
      for f in dirp
        case f
        when /^\./, /~$/, /\.o/
          # do not print
        else
          logger.info "#{Time.now.to_s(:db)} #{f}"
          code = f[0,15]
          mobile = f[0,11]
          birth = f[11,4]
          approve_status = f[15,2]
          task_type = f[17,2]
          design_type = f[19,2]
          design_effect = f[21,2]
          style_effect = f[23,2]
          fee_code = f[25,2]
          tasked_at = f[27,10]
          file_name = f
          Task.transaction do
            t = Task.new(:code=>code,
                        :mobile=>mobile,
                        :birth=>birth,
                        :approve_status=>approve_status,
                        :task_type=>task_type,
                        :design_type=>design_type,
                        :design_effect=>design_effect,
                        :style_effect=>style_effect,
                        :fee_code=>fee_code,
                        :tasked_at=>tasked_at,
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
                              :approve_status=>t.approve_status,
                              :task_type=>t.task_type,
                              :design_type=>design_type,
                              :design_effect=>design_effect,
                              :style_effect=>style_effect,
                              :fee_code=>fee_code,
                              :tasked_at=>tasked_at,
                              :source=>1)
                if i.save!
                  if t.file_name.match(/\./)
                    #file
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
      end
    rescue => e
      print_error(e)
    end
    logger.info "******************** parsed *********************"
  end
  
  def self.check_dir
    Dir.open(INCOMING)
    Dir.open(OUTPUT)
    Dir.open(FAILED)
    Dir.open(SUCCESS)
    Dir.open(OUTPUT_BK)
  end
  
  def self.print_error(e)
    logger.error ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    logger.error e
    logger.error ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end

protected
  def check_task_type
    t = Task.in_code(self.code).first
    case self.task_type
    when "10"
      errors.add(:task_type, "10 error") unless t.nil?
    when "20"
      errors.add(:task_type, "20 error") unless ["10","20"].include?(self.task_type)
    when "30"
      errors.add(:task_type, "30 error") unless ["20","30","40"].include?(self.task_type)
      errors.add(:file_name, "must be an attachment") unless self.file_name.match(/\./)
    when "40"
      errors.add(:task_type, "40 error") unless ["20","30","40"].include?(self.task_type)
      errors.add(:file_name, "can't be an attachment") if self.file_name.match(/\./)
    end
  end

  def check_design_type
    t_codes = Tracker.all.collect(&:code)
    case self.task_type
    when "10"
      errors.add(:design_type, "is not in the scope") unless t_codes.include?(self.design_type)
    when "20"
      errors.add(:design_type, "is not in the scope") unless (["00"]+t_codes).include?(self.design_type)
    when "30"
      errors.add(:design_type, "is not in the scope") unless t_codes.include?(self.design_type)
    when "40"
      errors.add(:design_type, "is not in the scope") unless (["00"]+t_codes).include?(self.design_type)
    end
  end
  
  def check_design_effect
    if self.design_type == "00"
      task = Task.not_in_design_type(self.design_type).last
      tracker = Tracker.in_code(task.design_type).first
    else
      tracker = Tracker.in_code(self.design_type).first
    end
    unless tracker.nil?
      d_codes = tracker.designs.all.collect(&:code)
      case self.task_type
      when "10"
        errors.add(:design_effect, "is not in the scope") unless d_codes.include?(self.design_effect)
      when "20"
        errors.add(:design_effect, "is not in the scope") unless (["00"]+d_codes).include?(self.design_effect)
      when "30"
        errors.add(:design_effect, "is not in the scope") unless d_codes.include?(self.design_effect)
      when "40"
        errors.add(:design_effect, "is not in the scope") unless (["00"]+d_codes).include?(self.design_effect)
      end
    end
  end
  
  def check_style_effect
    case self.task_type
    when "10"
      errors.add(:style_effect, "is not in the scope") unless ["01","02"].include?(self.style_effect)
    when "20"
      errors.add(:style_effect, "is not in the scope") unless ["00","01","02"].include?(self.style_effect)
    when "30"
      errors.add(:style_effect, "is not in the scope") unless ["01","02"].include?(self.style_effect)
    when "40"
      errors.add(:style_effect, "is not in the scope") unless ["00","01","02"].include?(self.style_effect)
    end
  end
end
