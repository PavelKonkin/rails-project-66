# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthUserConcern
  include Pundit::Authorization

  helper_method :current_user, :sign_in, :sign_out, :signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = t('.not_authorized')
    redirect_back(fallback_location: root_path)
  end
end
