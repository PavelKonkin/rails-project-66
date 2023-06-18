# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  aasm skip_validation_on_save: true, whiny_transitions: false, column: 'state' do
    state :created, initial: true
    state :in_process, :completed

    event :start do
      transitions from: :created, to: :in_process
    end

    event :complete do
      transitions from: :in_process, to: :completed
    end
  end
  belongs_to :repository
end
