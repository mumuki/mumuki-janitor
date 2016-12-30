module Api
  class CoursesController < BaseController
    before_action :set_slug, only: :create
    before_action :protect!, only: :create

    def create
      course = Course.create! course_params
      course.notify!
      render json: { course: course }
    end

    private

    def course_params
      params.require(:course).permit(:slug, :code, :period, :description, :subscription_mode, shifts: [], days: [])
    end

    def set_slug
      @slug = Mumukit::Auth::Slug.parse course_params[:slug]
    end

    def protect!
      @api_client.protect! :janitor, @slug
    end

  end
end