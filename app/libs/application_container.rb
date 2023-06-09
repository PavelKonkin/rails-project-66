# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_api, -> { OctokitApiStub }
    register :eslint_api, -> { EslintApiStub }
    register :rubocop_api, -> { RubocopApiStub }
  else
    register :octokit_api, -> { OctokitApi }
    register :eslint_api, -> { EslintApi }
    register :rubocop_api, -> { RubocopApi }
  end
end
