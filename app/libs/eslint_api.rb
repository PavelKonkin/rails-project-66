# frozen_string_literal: true

require 'open3'
class EslintApi
  def self.check_repo(current_user, repository, check)
    repo = ApplicationContainer[:octokit_api].repo(current_user, repository.full_name)
    folder_path = Rails.root.join(repo[:name])

    remove_repo(repo[:name], folder_path)

    Open3.capture2("git clone #{repo['clone_url']}")
    check.start!
    check_result, status = Open3.popen3("node_modules/eslint/bin/eslint.js #{repo[:name]} -c .eslintrc.yml -f json") { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
    passed = status.exitstatus.zero?
    CheckAlertMailer.with(user: current_user, check:).send_mail.deliver_later unless passed
    check.finish!
    processed_check_result, error_count = parse_json_result(check_result, repo)

    remove_repo(repo[:name], folder_path)

    commit = ApplicationContainer[:octokit_api].commit(current_user, repo[:full_name])
    commit_id = commit['sha'][0...7]
    commit_link = commit['html_url']
    check.update(check_result: processed_check_result, passed:, commit_id:, commit_link:, error_count:)
  end

  def self.path_to_file_on_github(local_file_path, repo_full_name, repo_name)
    github_url = "https://github.com/#{repo_full_name}/blob/main"
    relative_path = local_file_path.sub(%r{.*/#{repo_name}/}, '')
    file_path = "#{github_url}/#{relative_path}"
    { file_path:, relative_path: }
  end

  def self.remove_repo(repo_name, repo_path)
    return unless File.directory?(repo_path)

    FileUtils.rm_rf(repo_name)
  end

  def self.parse_json_result(check_result, repo)
    error_count = 0
    processed_check_result = []
    JSON.parse(check_result).each do |repo_file|
      next if repo_file['errorCount'].zero?

      error_count += repo_file['errorCount']
      file_hash = {}
      file_info = path_to_file_on_github(repo_file['filePath'], repo[:full_name], repo[:name])
      file_hash[:file_path] = file_info[:file_path]
      file_hash[:relative_path] = file_info[:relative_path]
      file_hash[:messages] = []
      repo_file['messages'].each do |message|
        file_hash[:messages] << { rule_id: message['ruleId'], message_text: message['message'], line_symbol: "#{message['line']}:#{message['column']}" }
      end
      processed_check_result << file_hash
    end
    [processed_check_result, error_count]
  end
end
