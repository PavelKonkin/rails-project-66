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
    client(current_user).commits(repo_full_name).last
  end
end
