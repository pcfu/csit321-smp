module Admin
    class ScheduleController < ApplicationController
        before_action :redirect_if_not_admin
        def index
            @models = ModelConfig.all
            @schedule = TrainingSchedule.all
        end


        def edit
        end
    end 
end
