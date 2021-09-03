class BackendClient
  URL = Rails.configuration.backend_url

  class << self
    def get(endpoint = '/', params = {})
      build_and_send_request('get', endpoint, params.to_json)
    end

    def post(endpoint, data)
      build_and_send_request('post', endpoint, data.to_json)
    end


    private
      def build_and_send_request(method, endpoint, json)
        uri = build_uri(endpoint)
        http = Net::HTTP.new(uri.host, uri.port)
        add_ssl(http) if Rails.env.production?

        header = {'Content-Type' =>'application/json'}
        request = get_interface(method).new(uri.path, initheader = header)
        request.body = json
        http.request(request)
      end

      def build_uri(endpoint)
        endpoint = '/' + endpoint if endpoint[0] != '/'
        URI.parse("#{URL}#{endpoint}")
      end

      def add_ssl(http)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      def get_interface(method)
        if method == 'get'
          Net::HTTP.const_get(:Get)
        elsif method == 'post'
          Net::HTTP.const_get(:Post)
        end
      end
  end
end
