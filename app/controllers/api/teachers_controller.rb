module Api
  class TeachersController < PeopleController
    private

    def role
      :teacher
    end
  end
end