# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user_info = receive_user_info
    user = User.find_or_initialize_by(email: user_info[:email])
    user.name = user_info[:name]
    user.token = user_info[:token]
    user.nickname = user_info[:nickname]
    if user.save
      sign_in user
      redirect_to root_path, notice: t('.signed_in')
    else
      redirect_to auth_request_path :github, notice: t('.sign_in_failed')
    end
  end

  private

  def receive_user_info
    omniauth_data = request.env['omniauth.auth']
    { email: omniauth_data['info']['email'].downcase, name: omniauth_data['info']['name'], token: omniauth_data['credentials']['token'], nicknam: omniauth_data['credentials']['nickname'] }
  end
end
