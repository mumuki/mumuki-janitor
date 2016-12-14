module Api
  class CoursesController < BaseController

    def create
      course = Course.create! course_params
      render json: { course: course }
    end

    private

    def course_params
      params.require(:course).permit(:slug, :code, :period, :description, :subscription_mode, shifts: [], days: [])
    end

  end
end