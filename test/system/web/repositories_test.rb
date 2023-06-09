# frozen_string_literal: true

require 'application_system_test_case'

class Web::RepositoriesTest < ApplicationSystemTestCase
  setup do
    @web_repository = web_repositories(:one)
  end

  test 'visiting the index' do
    visit web_repositories_url
    assert_selector 'h1', text: 'Repositories'
  end

  test 'should create repository' do
    visit web_repositories_url
    click_on 'New repository'

    fill_in 'Language', with: @web_repository.language
    fill_in 'Title', with: @web_repository.title
    fill_in 'User', with: @web_repository.user_id
    click_on 'Create Repository'

    assert_text 'Repository was successfully created'
    click_on 'Back'
  end

  test 'should update Repository' do
    visit web_repository_url(@web_repository)
    click_on 'Edit this repository', match: :first

    fill_in 'Language', with: @web_repository.language
    fill_in 'Title', with: @web_repository.title
    fill_in 'User', with: @web_repository.user_id
    click_on 'Update Repository'

    assert_text 'Repository was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Repository' do
    visit web_repository_url(@web_repository)
    click_on 'Destroy this repository', match: :first

    assert_text 'Repository was successfully destroyed'
  end
end
