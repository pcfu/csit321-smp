module Admin
  class ModelParametersController < ApplicationController
    before_action :logged_in_user
    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def index
      @models = ModelConfig.all

    end
    
    def show
      @model = ModelConfig.find(params[:id])
      
      respond_to do |format|
        format.html
      end
    end

    def new
    @ml_params = ModelConfig.new
    end

    def create
      #Extracting values from form
      @name_param = params[:model_config][:name]
      @model_param = params[:model_config][:model_type]
      @start_date = params[:model_config][:start_date]
      @train_test_param =  params[:model_config][:train_test_percent]
      #svm
      @c =  params[:model_config][:c].select!{|val| !val.empty?}
      @gamma =  params[:model_config][:gamma].select!{|val| !val.empty?}
      @kernel =  params[:model_config][:kernel].select!{|val| !val.empty?}
      #rf
      @n_estimators =  params[:model_config][:n_estimators].select!{|val| !val.empty?}
      @max_depth =  params[:model_config][:max_depth].select!{|val| !val.empty?}
      @max_features =  params[:model_config][:max_features].select!{|val| !val.empty?}
      @criterion =  params[:model_config][:criterion].select!{|val| !val.empty?}
      #lstm
      @activation =  params[:model_config][:activation]
      @units =  params[:model_config][:units]
      @dropout =  params[:model_config][:dropout]
      @epoch =  params[:model_config][:epoch]
      @batch_size =  params[:model_config][:batch_size]


      #Defining the json string
      if @model_param == "lstm"   #LSTM
        @parameter = {
          :start_date =>@start_date, 
          :train_test_percent =>@train_test_param,
          :build_args=>{:activation=>@activation, 
                        :units=>@units,
                        :dropout=>@dropout,
                        :epoch=>@epoch}
                      }.to_json
      elsif @model_param == "svm"    #SVM
          @parameter = {
            :start_date =>@start_date, 
            :train_test_percent =>@train_test_param,
            :build_args=>{:c=>@c, 
                          :gamma=>@gamma,
                          :kernel=>@kernel}
                        }.to_json
      else      #RF
        @parameter = {
          :start_date =>@start_date, 
          :train_test_percent =>@train_test_param,
          :build_args=>{:n_estimators=>@n_estimators, 
                        :max_depth=>@max_depth,
                        :max_features=>@max_features,
                        :criterion=>@criterion}
                       }.to_json

      end

      

      #Creating new train model
      @ml_params = ModelConfig.create(name: @name_param,model_type:@model_param, train_percent:0, params:@parameter)
      
      #Saving model
      if @ml_params.save
        #Set all active state as false
        setInactive(@model_param)
        @ml_params.update(:active =>true)
        flash[:success] = "ML parameters saved successfully"
        redirect_to admin_model_parameters_path  # change this redirect to index later
      else
        flash.now[:error] = "Error: parameters could not be saved"
        render :new
      end
    end

    def destroy
      @active_status = ModelConfig.find(params[:id])[:active]
      if @active_status == false
        @model = ModelConfig.find(params[:id])
        @model.destroy
        flash[:success] = "Parameters deleted"
        redirect_to admin_model_parameters_path
      else
        flash[:error] = "Error: You cannot delete active parameters."
        redirect_to admin_model_parameters_path
      end

    end


    def setActive
      #Set all the other historical parameters inactive
     # @model_type_toactive = ModelConfig.select(:model_type).find(params[:id])
      @model_type_toactive = ModelConfig.find(params[:id])[:model_type]
      setInactive(@model_type_toactive)

      #Set selected parameter active
      @model_toactive = ModelConfig.find(params[:id])
      @model_toactive.update(:active =>true)
      flash[:success] = "Active Model Parameters Updated"
      redirect_to admin_model_parameters_path
      respond_to do |format|
        format.html{}
        format.js{}
      end

    end

    private

    def setInactive(modeltype)
      if modeltype == "svm"
        ModelConfig.where(model_type:"rf", active:true).update_all(active:false)
      elsif modeltype == "rf"
        ModelConfig.where(model_type:"svm", active:true).update_all(active:false)
      end
      ModelConfig.where(model_type:modeltype, active:true).update_all(active:false)
    end


  end


end
