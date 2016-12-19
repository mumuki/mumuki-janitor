module Api
  class StudentsController < BaseController
    before_action :set_slug, only: :create
    before_action :set_course, only: :create
    before_action :protect!, only: :create

    def create
      @course.add_student!(user_params)
      render json: { status: :created }
    end

    private

    def user_params
      params.require(:student).permit(:first_name, :last_name, :email, :uid)
    end

    def set_course
      @course = Course.find_by(slug: @slug)
    end

    def set_slug
      @slug = Mumukit::Auth::Slug.join_s params.to_unsafe_h
    end

    def protect!
      @api_client.protect! :janitor, @slug
    end

  end

end