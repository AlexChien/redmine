class CardTask < ActiveRecord::Base
  unloadable
  
  validates_presence_of :code, :mobile, :birth
  validates_presence_of :source, :design_type, :design_effect, :style_effect, :gallery_code, :file_name, :if => "task_status == 3"
  validates_format_of :code, :with => /^\d{15}$/
  validates_format_of :mobile, :with => /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}$/
  validates_format_of :birth, :with => /^(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/
  validates_format_of :source, :with => /^(  |88|99)$/, :if => "task_status == 3"
  validates_format_of :design_type, :with => /^(  |\d{2})$/, :if => "task_status == 3"
  validates_format_of :design_effect, :with => /^(  |\d{2})$/, :if => "task_status == 3"
  validates_format_of :style_effect, :with => /^0|1|2|3|4|A|B|C|D|E$/, :if => "task_status == 3"
  validates_format_of :gallery_code, :with => /^(  |\d{2})$/, :if => "task_status == 3"
  validates_format_of :task_type, :with => /^( |0|1)$/
    
  named_scope :in_code, lambda {|code|
    {:conditions => ["card_tasks.code in (?)", code]}
  }
  
  named_scope :in_task_type, lambda {|task_type|
    {:conditions => ["card_tasks.task_type in (?)", task_type]}
  }
  
  named_scope :not_in_design_type, lambda {|design_type|
    {:conditions => ["card_tasks.design_type not in (?)", design_type]}
  }

end
