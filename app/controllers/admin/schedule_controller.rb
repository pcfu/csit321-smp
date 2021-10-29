module Admin
    class ScheduleController < ApplicationController
        before_action :redirect_if_not_admin
        def index
            @models = ModelConfig.all
            @schedule = TrainingSchedule.all
        end


        def edit
            @schedule = TrainingSchedule.find(params[:id])
            respond_to do |format|
                format.html{}
                format.js{}
            end
        end

        def update
            @schedule = TrainingSchedule.find(params[:id])
            if @schedule.update(schedule_params)
                flash[:success] = "Schedule is successfully updated"
                redirect_to admin_schedule_index_path
            else
                flash[:error] = "Schedule update has failed"
                render :edit
            end

        end

        private

        def schedule_params
            params.require(:training_schedule).permit(:start_date,:frequency)
        end
                
    end 
end
