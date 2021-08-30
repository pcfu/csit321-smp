class AdminChannel < ApplicationCable::Channel
  rescue_from StandardError, with: :broadcast_error_message

  def subscribed
    stream_from "admin_channel"
  end

  def self.broadcast(message)
    ActionCable.server.broadcast("admin_channel", message)
  end


  private

    def broadcast_error_message(e)
      # Do something here...
    end
end
