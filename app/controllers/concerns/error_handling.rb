module ErrorHandling
  extend ActiveSupport::Concern

  class ErrorFlagger
    attr_accessor :error

    def flag(error)
      @error = error
      raise StandardError
    end

    def e_msg
      @error[:message] if @error.present?
    end

    def e_code
      @error[:code] if @error.present?
    end
  end


  def with_error_handling
    begin
      flagger = ErrorFlagger.new
      yield flagger

    rescue StandardError => e
      msg = flagger.e_msg || e.message
      code = flagger.e_code || :internal_server_error
      render json: { status: 'error', message: msg }, status: code
    end
  end


  def handle_error(e)
    msg = e.respond_to?(:original_message) ? e.original_message : e.message
    code = e.is_a?(ActionController::ParameterMissing) ?
             :unprocessable_entity : :internal_server_error
    render json: { status: 'error', message: msg }, status: code
  end
end
