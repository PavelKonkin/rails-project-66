# frozen_string_literal: true

module AuthUserConcern
  def authenticate_user
    return if user_signed_in?

    redirect_to root_path, alert: t('.forbidden')
  end

  def user_signed_in?
    current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end
end
