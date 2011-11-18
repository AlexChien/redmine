class Task < ActiveRecord::Base
  unloadable
  
  validates_presence_of :code, :mobile, :birth
  validates_presence_of :source, :design_type, :design_effect, :style_effect, :file_name, :if => "task_status == 3"
  validates_format_of :code, :with => /^\d{15}$/
  validates_format_of :mobile, :with => /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}$/
  validates_format_of :birth, :with => /^(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/
  validates_format_of :design_type, :with => /^\d{2}$/, :if => "task_status == 3"
  validates_format_of :design_effect, :with => /^\d{2}$/, :if => "task_status == 3"
  validates_format_of :style_effect, :with => /^ |1|2$/, :if => "task_status == 3"
  validates_format_of :source, :with => /^88|99$/, :if => "task_status == 3"
  validates_format_of :task_type, :with => /^ |0|1$/
    
  named_scope :in_code, lambda {|code|
    {:conditions => ["tasks.code in (?)", code]}
  }
  
  named_scope :in_task_type, lambda {|task_type|
    {:conditions => ["tasks.task_type in (?)", task_type]}
  }
  
  named_scope :not_in_design_type, lambda {|design_type|
    {:conditions => ["tasks.design_type not in (?)", design_type]}
  }
  
  TASK_TYPES = {
    ' ' => '新卡申请',
    '0' => '换卡换图',
    '1' => '换卡不换图'
  }
  
  LAYOUTS = {
    '1' => '横版',
    '2' => '竖版'
  }

end
