class BackendClient
  URL = Rails.configuration.backend_url

  class << self
    def get(endpoint = '/')
      uri = build_uri(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      add_ssl(http) if Rails.env.production?
      http.request(Net::HTTP::Get.new(uri.request_uri))
    end

    def post(endpoint, data)
      uri = build_uri(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      add_ssl(http) if Rails.env.production?

      header = {'Content-Type' =>'application/json'}
      request = Net::HTTP::Post.new(uri.path, initheader = header)
      request.body = data.to_json
      http.request(request)
    end


    private

      def build_uri(endpoint)
        endpoint = '/' + endpoint if endpoint[0] != '/'
        URI.parse("#{URL}#{endpoint}")
      end

      def add_ssl(http)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
  end
end
