# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    author?
  end

  def index?
    @user
  end

  def new?
    create?
  end

  def create?
    @user
  end

  private

  def author?
    @record.user == @user
  end
end
