# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  def on_push
    repository = Repository.find_by(full_name: params['repository']['full_name'])
    return unless repository

    check = repository.checks.build
    check.save
    CheckJob.perform_later(user: repository.user, repo: repository, check:)
    render json: { status: 200 }
  end
end
