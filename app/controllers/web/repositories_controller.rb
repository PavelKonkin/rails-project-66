# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = Repository.find(params[:id])
    @checks = @repository.checks
    authorize @repository
  end

  def new
    @repository = Repository.new
    @repos = ApplicationContainer[:octokit_api].repos(current_user)
  end

  def create
    repo = ApplicationContainer[:octokit_api].repo(current_user, repository_params[:github_id])
    @repository = current_user.repositories.build(repository_params.merge({ language: repo['language'].downcase, title: repo['name'] }))
    authorize @repository
    if @repository.save
      SetWebhookJob.perform_later(user: current_user, repository: @repository)
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
