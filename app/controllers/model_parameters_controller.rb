class ModelParametersController < ApplicationController
  def new
    @ml_params = ModelParameter.new
  end

  def create
    @ml_params = ModelParameter.new create_params

    if @ml_params.save
      flash[:success] = "ML parameters saved successfully"
      redirect_to model_parameters_new_url  # change this redirect to index later
    else
      flash.now[:error] = "Error: parameters could not be saved"
      render :new
    end
  end


  private

    def create_params
      params.require(:model_parameter).permit(:name, :ml, :param_one, :param_two, :param_three,
                                              :train_set, :start_date, :end_date)
    end
end
