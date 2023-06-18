# frozen_string_literal: true

class Web::ChecksController < Web::ApplicationController
  def show
    @check = Repository::Check.find(params[:id])
    authorize @check
  end

  def create
    repository = Repository.find(params[:repository_id])
    # check_result = ApplicationContainer[:eslint_api].check_repo(current_user, repository)
    @check = repository.checks.build
    if @check.save
      ApplicationContainer[:eslint_api].check_repo(current_user, repository, @check)
      redirect_to repository, notice: t('.check_created')
    else
      redirect_to :new, status: :unprocessable_entity
    end
  end
end
