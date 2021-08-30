class AdminChannel < ApplicationCable::Channel
  rescue_from StandardError, with: :broadcast_error_message

  def subscribed
    stream_from "channel_admin"
  end

  private

    def broadcast_error_message(e)
      # Do something here...
    end
end
