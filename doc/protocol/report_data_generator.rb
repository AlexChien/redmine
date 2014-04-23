def concat(string)
  @str = "#{@str}#{@sep}#{string}"
end

task_types = %w(新卡申请 换卡换图 换卡不换图)
design_types = %w(手绘Q图卡通彩色 手绘Q图卡通黑白 手绘Q图写实彩色 手绘Q图写实黑白 场景版 图库自选版 客户上传版)
layouts = %w(横版 竖版)
issue_statuses = %w(VP00图片未提交 VP01待审核 VP02审核失败，收到多张照片 VP03图片审核中 VP04图片审核不通过 VP05制图中 VP06制图失败 VP07制图成功 VP08制图成功，使用默认图)

@str = ""
@sep = "\t"
@line = "\n"
rows = []

(0..2).each do |date_offset|
  date = (Time.now-86400*date_offset).strftime("%Y-%m-%d").to_s
  task_types.each do |tt|
    design_types.each do |dt|
      layouts.each do |lt|
        issue_statuses.each do |is|
          concat(date)
          concat(tt)
          concat(dt)
          concat(lt)
          concat(is)
          concat(rand(50))
          concat(@line)
        end
      end
    end
  end
end


puts @str