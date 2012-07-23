class DesignsController < ApplicationController
  unloadable
  layout 'admin'
  skip_before_filter :check_if_login_required, :only => [:stats]

  def index
    @designs = Design.all(:order=>"tracker_id ASC,code ASC")
  end
  
  def new
    @design = Design.new
  end

  def edit
    @design = Design.find(params[:id])
  end

  def create
    @design = Design.new(params[:design])
    if @design.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to(params[:continue] ? new_design_path : designs_path)
    else
      render :action => "new"
    end
  end
  
  def update
    @design = Design.find(params[:id])
    if @design.update_attributes(params[:design])
      flash[:notice] = l(:notice_successful_update)
      redirect_to(designs_path)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @design = Design.find(params[:id])
    @design.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :action => 'index'
  end
  
  def stats
    @issues = Issue.find_by_sql("
      select 
      date(issues.created_on) as d,
      issues.task_type as tt,
      issues.tracker_id as ti,
      trackers.name as tn,
      issues.design_id as di,
      designs.name as dn,
      issues.style_effect as se,
      issues.status_id as si,
      issue_statuses.name as isn,
      count(*) as c
      from issues
      left join trackers on issues.tracker_id      = trackers.id
      left join designs on issues.design_id        = designs.id
      left join issue_statuses on issues.status_id = issue_statuses.id
      group by d,tt,ti,di,se,si
    ")
    respond_to do |format|  
      format.xml
    end
  end
end
