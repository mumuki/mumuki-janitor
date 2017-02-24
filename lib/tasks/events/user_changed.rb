+module Office
  module Event
    class UserChanged
      def self.execute!(payload)
        User.update! payload.deep_symbolize_keys[:user]
      end
    end
  end
end