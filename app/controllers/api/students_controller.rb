module Api
  class StudentsController < PeopleController
    private

    def role
      :student
    end
  end
end