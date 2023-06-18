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
    assert { Repository::Check.last.repository == @repository }
    assert_redirected_to repository_url(@check.repository)
  end

  test 'should show check' do
    get check_url(@check)
    assert_response :redirect
  end
end
