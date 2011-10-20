class Design < ActiveRecord::Base
  unloadable
  belongs_to :tracker
  
  validates_presence_of :code, :name, :tracker_id
  validates_format_of :code, :with => /^\d{2}$/, :message => "不符合规则"
  validate :uniqueness_code
  
  named_scope :in_code, lambda {|code|
    {:conditions => ["designs.code = ?", code]}
  }
  
  named_scope :in_tracker, lambda {|tracker|
    {:conditions => ["designs.tracker_id = ?", tracker]}
  }

protected
  def uniqueness_code
    d = Design.in_tracker(self.tracker).in_code(self.code).first
    errors.add(:code, '同一类型下设计效果ID必须唯一！') if d && d != self
  end
end
