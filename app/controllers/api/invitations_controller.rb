module Api
  class InvitationsController < BaseController
    before_action :set_slug!
    before_action :set_course!
    before_action :authorize_janitor!

    EXPIRATION_DAYS = 7

    def index
      render json: { invitations: Invitation.all_of(@course) }
    end

    def create
      invitation = Invitation.create course: @course,
                                     expiration_date: (Date.today + EXPIRATION_DAYS).to_s
      invitation.notify!
      render json: invitation
    end

    private

    def set_slug!
      @slug = Mumukit::Auth::Slug.join_s params.to_unsafe_h
    end

    def set_course!
      @course = Course.find_by!(slug: @slug)
    end
  end

end