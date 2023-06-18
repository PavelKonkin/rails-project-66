# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    author?
  end

  def create?
    @user
  end

  private

  def author?
    @record.repository.user == @user
  end
end
