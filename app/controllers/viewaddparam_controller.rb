class ViewaddparamController < ActionController::Base
    def view_add_param
        mlParam = MlParam.new
        respond_to do |format|
            format.html{ render :viewaddparam, locals: { mlParam: mlParam } }
        end
    end

    def add_param
        # new object from params
        mlParam = MlParam.new(params.require(:ml_param).permit(:name, :ml, :paraOne, :paraTwo, :paraThree, :trainSet, :startDate, :endDate))
        # respond_to block
        respond_to do |format|
            format.html do
                if mlParam.save
                    # success message
                    flash[:success] = "ML parameters saved successfully"
                    # redirect to index
                    redirect_to model_url
                else
                    # error message
                    flash.now[:error] = "Error: parameters could not be saved"
                    # render new
                    render :viewaddparam, locals: { mlParam: mlParam }
                end
            end
        end
    end
end

