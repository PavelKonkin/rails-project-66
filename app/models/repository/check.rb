# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  aasm skip_validation_on_save: true, whiny_transitions: false, column: 'aasm_state' do
    state :created, initial: true
    state :in_process, :finished

    event :start do
      transitions from: :created, to: :in_process
    end

    event :finish do
      transitions from: :in_process, to: :finished
    end
  end
  belongs_to :repository
end
