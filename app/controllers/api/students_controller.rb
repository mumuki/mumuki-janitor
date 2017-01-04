module Api
  class StudentsController < BaseController
    before_action :set_slug
    before_action :set_course
    before_action :set_user, except: :create
    before_action :protect!

    def create
      user = User.create_if_necessary(user_params)
      user.attach! :student, @course
      render json: user.as_json
    end

    def attach
      @user.attach! :student, @course
      head :ok
    end

    def detach
      @user.detach! :student, @course
      head :ok
    end

    private

    def user_params
      params.require(:student).permit(:first_name, :last_name, :email, :uid, :image_url)
    end

    def set_course
      @course = Course.find_by!(slug: @slug)
    end

    def set_user
      @user = User.find_by!(uid: params[:uid])
    end

    def set_slug
      @slug = Mumukit::Auth::Slug.join_s params.to_unsafe_h
    end

    def protect!
      @api_client.protect! :janitor, @slug
    end

  end

end