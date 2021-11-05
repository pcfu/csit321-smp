class ThresholdController < ApplicationController
  #before_filter :redirect_cancel, :only=> [:create, :update]
  before_action :logged_in_user

  def new
    @threshold = Threshold.new
  end
  
  def create
    buy = params[:threshold][:buythreshold]
    sell = params[:threshold][:sellthreshold]
    if (buy>sell)
      redirect_to favorites_path, flash: {error: "Threshold not created. Buy Threshold value is higher than Sell Threshold"}
    else
      @threshold = Threshold.create(favorite:Favorite.find(params[:favoriteid]), buythreshold:buy, sellthreshold:sell)
      if @threshold.save
        redirect_to favorites_path,  flash: {notice: "Threshold has been created"}   
      else
        redirect_to favorites_path, flash: {error: "Unexpected Error"}
      end
    end  
  end

  def update
    @updatethreshold = Threshold.find(params[:thresholdid])
    buy = params[:threshold][:buythreshold]
    sell = params[:threshold][:sellthreshold]
    if (buy>=sell)
      redirect_to favorites_path, flash: {error: "Threshold not updated. Buy Threshold value should be lower than Sell Threshold"}
    else
      @updatethreshold.update(buythreshold:buy, sellthreshold:sell)
      if @updatethreshold.save
        redirect_to favorites_path,  flash: {notice: "Threshold has been updated"}  
      else
        redirect_to favorites_path, flash: {error: "Unexpected Error"}
      end 

    end  
    
  end

  private

  def redirect_cancel
    if params[:commit] == "Cancel"
      redirect_to favorites_path 
    end
  end
  

end
