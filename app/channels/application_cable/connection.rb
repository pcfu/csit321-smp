module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :connection_id

    def connect
      authenticate_connection
      self.connection_id = "#{request.params[:id]}_#{__id__}"
    end

    def disconnect
      logger.info "#{connection_id} disconnected"
    end

    private

      def authenticate_connection
        reject_unauthorized_connection if request.params[:id] != 'admin'
        ### add more verification to check client identity
      end
  end
end
