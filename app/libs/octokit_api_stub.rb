# frozen_string_literal: true

class OctokitApiStub
  def self.repos(_current_user)
    response = JSON.parse(File.read('test/fixtures/files/response.json'))
    lang_arr = Repository.language.values.collect(&:text)
    response.each_with_object([]) { |repo, arr| (arr << repo[:full_name]) if lang_arr.include? repo[:language] }
  end

  def self.repo(_current_user, _full_name)
    # response = JSON.parse(File.read('test/fixtures/files/response.json'))
    # response.find { |el| el['full_name'] == full_name }
    {
      github_id: '1234567',
      full_name: 'octocat/Hello-World',
      name: 'Hello-World',
      language: 'javascript'
    }
  end

  def self.set_webhook(_current_user, _repo); end
end
