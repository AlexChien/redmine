class DesignsController < ApplicationController
  unloadable
  layout 'admin'

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
end
