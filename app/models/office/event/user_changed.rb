module Office
  module Event
    class UserChanged
      def self.execute!(payload)
        User.import_from_json! payload[:user]
      end
    end
  end
end
