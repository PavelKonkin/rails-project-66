# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  def on_push
    repository = Repository.find_by(github_id: params['repository']['full_name'])
    return unless repository

    repo_language = repository.language.downcase
    if repo_language == 'ruby'
      linter = :rubocop_api
    elsif repo_language == 'javascript'
      linter = :eslint_api
    end
    check = repository.checks.build
    check.save
    ApplicationContainer[linter].check_repo(repository.user, repository, check)
    render json: { status: 200 }
  end
end
