class Task < ActiveRecord::Base
  unloadable
  
  validates_presence_of :code, :mobile, :birth, :approve_status, :task_type, :design_type,
                        :design_effect, :style_effect, :fee_code, :tasked_at, :file_name
  validates_uniqueness_of :file_name
  validates_format_of :code, :with => /^\d{15}$/
  validates_format_of :mobile, :with => /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}$/
  validates_format_of :birth, :with => /^(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/
  validates_format_of :approve_status, :task_type, :design_type,:design_effect,
                      :style_effect, :fee_code, :with => /^\d{2}$/
  validates_format_of :birth, :with => /^\d{10}$/

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
          logger.info "#{Time.now.to_s(:db)} #{f.basename}"
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

end
