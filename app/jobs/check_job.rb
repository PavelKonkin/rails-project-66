# frozen_string_literal: true

class CheckJob < ApplicationJob
  queue_as :default

  def perform(**args)
    repo_language = args[:repo].language.downcase
    if repo_language == 'ruby'
      linter = :rubocop_api
    elsif repo_language == 'javascript'
      linter = :eslint_api
    end
    ApplicationContainer[linter].check_repo(args[:user], args[:repo], args[:check])
  end
end
