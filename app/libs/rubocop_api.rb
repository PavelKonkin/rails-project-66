# frozen_string_literal: true

require 'open3'
class RubocopApi
  def self.check_repo(current_user, repository, check)
    repo = ApplicationContainer[:octokit_api].repo(current_user, repository.github_id)
    folder_path = Rails.root.join(repo[:name])
    if File.directory?(folder_path)
      FileUtils.rm_rf(repo[:name])
    end
    Open3.capture2("git clone #{repo['clone_url']}")
    check.start!
    check_result, status = Open3.popen3("rubocop #{folder_path} -c .rubocop.yml --format json") { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
    passed = status.exitstatus.zero?
    CheckAlertMailer.with(user: current_user, check:).send_mail.deliver_later unless passed
    check.complete!
    processed_check_result = []

    json_result = JSON.parse(check_result)

    error_count = json_result['summary']['offense_count']
    if error_count.positive?
      json_result['files'].each do |repo_file|
        next if repo_file['offenses'].empty?

        file_hash = {}
        file_info = path_to_file_on_github(repo_file['path'], repo[:full_name], repo[:name])
        file_hash[:file_path] = file_info[:file_path]
        file_hash[:relative_path] = file_info[:relative_path]
        file_hash[:messages] = []
        repo_file['offenses'].each do |offense|
          file_hash[:messages] << { rule_id: offense['cop_name'], message_text: offense['message'], line_symbol: "#{offense['location']['start_line']}:#{offense['location']['start_column']}" }
        end
        processed_check_result << file_hash
      end
    end

    if File.directory?(folder_path)
      FileUtils.rm_rf(repo[:name])
    end
    commit = ApplicationContainer[:octokit_api].commit(current_user, repo[:full_name])
    commit_id = commit['sha'][0...7]
    commit_link = commit['html_url']
    check.update(check_result: processed_check_result, passed:, commit_id:, commit_link:, error_count:)
  end

  def self.path_to_file_on_github(local_file_path, repo_full_name, repo_name)
    github_url = "https://github.com/#{repo_full_name}/blob/main"
    relative_path = local_file_path.sub(%r{.*#{repo_name}/}, '')
    file_path = "#{github_url}/#{relative_path}"
    { file_path:, relative_path: }
  end
end
