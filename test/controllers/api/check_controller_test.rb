# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @repository = repositories(:api)
    @attributes = { full_name: @repository.full_name }
  end

  test 'should create check' do
    post api_checks_url params: { repository: @attributes }
    check = Repository::Check.last
    assert { check.repository == @repository }
    assert { check.finished? }
    assert { check.passed }
    assert_response 200
  end
end
