# frozen_string_literal: true

require 'test_helper'

class Web::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @repository = repositories(:one)
    @check = repository_checks(:one)
  end

  test 'should create check' do
    post repository_checks_url(@repository)
    check = @repository.checks.last
    assert_redirected_to repository_url(@repository)
    assert { check.repository == @repository }
    assert { check.finished? }
  end

  test 'should show check' do
    get repository_check_url(@repository, @check)
    assert_response :redirect
  end
end
