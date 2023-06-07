# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthUserConcern

  helper_method :current_user, :sign_in, :sign_out, :signed_in?
end
