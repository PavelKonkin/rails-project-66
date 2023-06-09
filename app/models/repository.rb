# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize
  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  enumerize :language, in: %i[javascript ruby], I18n_scope: 'language'
  validates :github_id, presence: true, uniqueness: true
end
