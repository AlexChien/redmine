xml = Builder::XmlMarkup.new(:indent =>2)
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.data do
  issues=@issues
  issues.each do |li|
    xml.row do
      xml.date(li.d)
      xml.tt(Issue::TASK_TYPES[li.tt])
      xml.dt("#{li.tn}#{li.dn}")
      xml.lt("#{Issue::STYLE_EFFECT[li.se]}")
      xml.is(li.isn)
      xml.count(li.c)
    end
  end
end