class ThresholdController < ApplicationController
  #before_filter :redirect_cancel, :only=> [:create, :update]
  before_action :logged_in_user

  def new
    @threshold = Threshold.new
  end
  
  def create
    @threshold = Threshold.create(favorite:Favorite.find(params[:favoriteid]), buythreshold:params[:threshold][:buythreshold], sellthreshold:params[:threshold][:sellthreshold])
    @threshold.save
    if @threshold.save
      redirect_to favorites_path, :alert=>"Threshold has been created"   
    else
      redirect_to '/', :alert=>"Something went wrong"   
    end  
  end

  def update
    @updatethreshold = Threshold.find(params[:thresholdid])
    @updatethreshold.update(buythreshold:params[:threshold][:buythreshold], sellthreshold:params[:threshold][:sellthreshold])
    redirect_to favorites_path, :alert=>"Threshold has been updated"   
  end

  private

  def redirect_cancel
    if params[:commit] == "Cancel"
      redirect_to favorites_path 
    end
  end
  

end
