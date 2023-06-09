# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository
  end

  def new
    @repository = Repository.new
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    lang_arr = Repository.language.values.collect(&:text)
    @repos = client.repos.each_with_object([]) { |repo, arr| (arr << repo[:full_name]) if lang_arr.include? repo.language }
    # debugger
  end

  def create
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    repo = client.repos.find { |el| el.full_name == repository_params[:github_id] }
    @repository = current_user.repositories.build(repository_params.merge({ language: repo[:language].downcase, title: repo[:name] }))
    authorize @repository
    if @repository.save
      redirect_to repository_url(@repository), notice: t('.repository_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
