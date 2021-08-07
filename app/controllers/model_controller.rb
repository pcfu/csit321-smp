class ModelController < ActionController::Base
    def list_model
        render :model_list, locals: { name: 'joey'}
    end

    def add_model
        required = [:name, :machinemodel, :parameter1, :parameter2, :parameter3, :datatrainset, :startdate, :enddate]
        form_complete = true
        required.each do |f|
          if params.has_key? f and not params[f].blank?
            # that's good news. do nothing
          else
            form_complete = false
          end
        end

        if form_complete
            form_status_msg = 'Thank you for your feedback!'
          else
            form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
        end

        render :mlparam, locals: { name: 'joey', status_msg: form_status_msg, feedback: params}
    end

    def view_model
        render :model_details, locals: { name: 'joey'}
    end
end
