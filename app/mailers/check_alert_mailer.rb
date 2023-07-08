# frozen_string_literal: true

class CheckAlertMailer < ApplicationMailer
  def send_mail
    @user = params[:user]
    @check = params[:check]
    mail(
      to: @user.email,
      subject: t('.check_failed')
    )
  end
end
