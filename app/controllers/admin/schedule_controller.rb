module Admin
    class ScheduleController < ApplicationController
        before_action :redirect_if_not_admin
        def index
        end

        def edit
        end
    end 
end
