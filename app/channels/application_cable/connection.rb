module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :connection_id
  end
end
