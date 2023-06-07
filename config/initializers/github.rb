# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  if ENV['RAILS_ENV'] == 'production'
    github_key = ENV.fetch('GITHUB_CLIENT_ID', nil)
    github_secret = ENV.fetch('GITHUB_CLIENT_SECRET', nil)
  else
    github_key = ENV.fetch('DEV_GITHUB_CLIENT_ID', nil)
    github_secret = ENV.fetch('DEV_GITHUB_CLIENT_SECRET', nil)
  end
  provider :github, github_key, github_secret, scope: 'user, public_repo, admin:repo_hook'
end
