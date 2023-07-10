# frozen_string_literal: true

class OctokitApi
  def self.client(current_user)
    Octokit::Client.new access_token: current_user.token, auto_paginate: true
  end

  def self.repos(current_user)
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    lang_arr = Repository.language.values.collect(&:text)
    client.repos.each_with_object([]) { |repo, arr| (arr << repo[:full_name]) if lang_arr.include? repo.language }
  end

  def self.repo(current_user, github_id)
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    client.repos.find { |el| el.full_name == github_id }
  end

  def self.commit(current_user, repo_full_name)
    client(current_user).commits(repo_full_name).first
  end

  def self.set_webhook(current_user, repo)
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    delete_webhook(current_user, repo)
    client.create_hook(repo.github_id, 'web', {
                         url: Rails.application.routes.url_helpers.url_for(controller: 'api/checks', action: 'on_push'),
                         content_type: 'json'
                       }, {
                         events: ['push'],
                         active: true
                       })
  end

  def self.delete_webhook(current_user, repo)
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    repo_name = repo.github_id
    webhook_url = Rails.application.routes.url_helpers.url_for(controller: 'api/checks', action: 'on_push')
    hooks = client.hooks(repo_name)
    hooks.each do |hook|
      if hook.config.url == webhook_url
        client.remove_hook(repo_name, hook[:id])
      end
    end
  end
end
