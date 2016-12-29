module Office
  module Event
    class CourseChanged
      def self.execute!(payload)
        Course.import_from_json! payload[:course]
      end
    end
  end
end
