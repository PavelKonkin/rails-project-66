# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @repository = repositories(:one)
    @params = { repository: { full_name: 'test/test' } }
  end

  test 'should get index' do
    get repositories_url
    assert_response :success
  end

  test 'should get new' do
    # stub_request(:get, 'https://api.github.com/user/repos?per_page=100').to_return({ body: @response, headers: { content_type: 'application/json; charset=utf-8' } })
    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    # stub_request(:get, 'https://api.github.com/user/repos?per_page=100').to_return({ body: @response, headers: { content_type: 'application/json; charset=utf-8' } })
    post repositories_url, params: @params
    assert { Repository.last.full_name == @params[:repository][:full_name] }
    assert_redirected_to repository_url(Repository.last)
  end

  test 'should show repository' do
    get repository_url(@repository)
    assert_response :redirect
  end
end
