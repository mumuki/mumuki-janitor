module Api
  class StudentsController < BaseController
    before_action :set_slug, only: [:create, :attach]
    before_action :set_course, only: [:create, :attach]
    before_action :protect!, only: [:create, :attach]

    def create
      user = @course.add_student!(user_params)
      render json: user.as_json
    end

    def attach
      @course.attach!(params[:uid])
      render json: {status: :created}
    end

    private

    def user_params
      params.require(:student).permit(:first_name, :last_name, :email, :uid, :image_url)
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