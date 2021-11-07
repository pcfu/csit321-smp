module BackendConnectionChecking
  extend ActiveSupport::Concern

  def connection_up?
    begin
      BackendClient.ping
      true
    rescue
      puts "========================"
      puts "No connection to backend"
      puts "========================"
      false
    end
  end
end
