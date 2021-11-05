module Admin
  class ModelParametersController < ApplicationController
    before_action :logged_in_user
    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def index
      @models = ModelConfig.all

    end
    
    def show
      @model = ModelConfig.find(params[:id])
      @model_trained = ModelTraining.where(model_config:@model)
      
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
      @c =  params[:model_config][:c].select!{|val| !val.empty?}.map(&:to_i)
      @gamma =  params[:model_config][:gamma].select!{|val| !val.empty?}.map(&:to_i)
      @kernel =  params[:model_config][:kernel].select!{|val| !val.empty?}
      #rf
      @n_estimators =  params[:model_config][:n_estimators].select!{|val| !val.empty?}.map(&:to_i)
      @max_depth =  params[:model_config][:max_depth].select!{|val| !val.empty?}.map(&:to_i)
      @max_features =  params[:model_config][:max_features].select!{|val| !val.empty?}
      @criterion =  params[:model_config][:criterion].select!{|val| !val.empty?}
      #lstm
      @activation =  params[:model_config][:activation]
      @units =  params[:model_config][:units].to_i
      @dropout =  params[:model_config][:dropout].to_f
      @epoch =  params[:model_config][:epoch].to_f
      @batch_size =  params[:model_config][:batch_size].to_i


      #Defining the json string
      if @model_param == "lstm"   #LSTM
        @parameter = {
          :start_date =>@start_date, 
          :train_test_percent =>@train_test_param,
          :build_args=>{:activation=>@activation, 
                        :units=>@units,
                        :dropout=>@dropout,
                        :epoch=>@epoch,
                        :batch_size=>@batch_size}
                      }.to_json
      elsif @model_param == "svm"    #SVM
          @parameter = {
            :start_date =>@start_date, 
            :train_test_percent =>@train_test_param,
            :build_args=>{:C=>@c, 
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
      @ml_params = ModelConfig.create(name: @name_param,model_type:@model_param, train_percent:0, params:@parameter, active:false)
      
      #Saving model
      if @ml_params.save
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

    def train
      @model_totrain = ModelConfig.find(params[:id])
      @model_totrain.update(:train_percent=>100)
      flash[:success] = "Parameters trained 100%"
      redirect_to admin_model_parameters_path
    end


    def setActive
      @model_toactive = ModelConfig.find(params[:id])
      if @model_toactive.train_percent == 0
        flash[:error] = "You cannot set untrained parameters as active parameters"
        redirect_to admin_model_parameters_path
      else
        #Set all the other historical parameters inactive
        @model_type_toactive = ModelConfig.find(params[:id])[:model_type]
        setInactive(@model_type_toactive)
        #Set selected parameter active
        @model_toactive.update(:active =>true)
         #Creating default schedule
        TrainingSchedule.create(model_config:@model_toactive,start_date:Date.current,frequency:7)
        flash[:success] = "Active Model Parameters Updated"
        redirect_to admin_model_parameters_path
        respond_to do |format|
          format.html{}
          format.js{}
        end
      
      end

    end

    private

    def setInactive(modeltype)
      if modeltype == "svm"
        ModelConfig.where(model_type:"rf", active:true).update_all(active:false)
        destroySchedule("rf")
      elsif modeltype == "rf"
        ModelConfig.where(model_type:"svm", active:true).update_all(active:false)
        destroySchedule("svm")
      end
      currentModelId=ModelConfig.where(model_type:modeltype, active:true)
      ModelConfig.where(model_type:modeltype, active:true).update_all(active:false)
      destroySchedule(modeltype)
    end

    def destroySchedule(modeltype)
      current_schedule = TrainingSchedule.where(model_config:ModelConfig.where(model_type:modeltype))
      if current_schedule != []
        current_schedule.destroy_all
      end
    end


  end


end
