module ErrorHandling
  extend ActiveSupport::Concern

  def handle_error(e)
    msg = e.respond_to?(:original_message) ? e.original_message : e.message
    code = e.is_a?(ActionController::ParameterMissing) ?
             :unprocessable_entity : :internal_server_error
    render json: { status: 'error', message: msg }, status: code
  end
end
