require 'redmine'

Redmine::Plugin.register :redmine_designs do
  name 'Redmine Designs plugin'
  author 'brother j'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  
  permission :polls, { :polls => [:index, :vote] }
  menu :admin_menu, :designs, { :controller => 'designs', :action => 'index' }, :caption => '设计效果'
end
