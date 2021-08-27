Rails.application.configure do
  host = ENV['BACKEND_HOST']
  config.backend_url = Rails.env.production? ? "https://#{host}" : "http://#{host}:5000"
end
