# frozen_string_literal: true

class Web::ChecksController < Web::ApplicationController
  def show
    @check = Repository::Check.find(params[:id])
    authorize @check
  end

  def create
    repository = Repository.find(params[:repository_id])
    @check = repository.checks.build
    if @check.save
      CheckJob.perform_later(user: current_user, repo: repository, check: @check)
      redirect_to repository, notice: t('.check_created')
    else
      redirect_to :new, status: :unprocessable_entity
    end
  end
end
