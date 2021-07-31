class ModelController < ActionController::Base
    def list_model
        render :model_list, locals: { name: 'joey'}
    end

    def add_model
        render :new_model, locals: { name: 'joey'}
    end

    def view_model
        render :model_details, locals: { name: 'joey'}
    end
end
