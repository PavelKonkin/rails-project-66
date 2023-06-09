# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize
  belongs_to :user

  enumerize :language, in: %i[javascript], I18n_scope: 'language'
  validates :github_id, presence: true, uniqueness: true
end
