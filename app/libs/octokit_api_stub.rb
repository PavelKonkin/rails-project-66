# frozen_string_literal: true

class OctokitApiStub
  def self.repos(_current_user)
    response = JSON.parse(File.read('test/fixtures/files/response.json'))
    lang_arr = Repository.language.values.collect(&:text)
    response.each_with_object([]) { |repo, arr| (arr << repo[:full_name]) if lang_arr.include? repo[:language] }
  end

  def self.repo(_current_user, github_id)
    response = JSON.parse(File.read('test/fixtures/files/response.json'))
    response.find { |el| el['full_name'] == github_id }
  end
end