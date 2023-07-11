# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @repository = repositories(:api)
    @attributes = { full_name: @repository.github_id }
  end

  test 'should create check' do
    post api_checks_url params: { repository: @attributes }
    assert { Repository::Check.last.repository == @repository }
    assert_response 200
  end
end
