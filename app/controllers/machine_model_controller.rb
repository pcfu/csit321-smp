class MachineModelController < ActionController::Base
    def machine_model_list
        render :machine_model_list, locals: { name: 'pred'}
    end

    def add_machine_model
        render :add_machine_model, locals: { name: 'pred'}
    end

end
