# frozen_string_literal: true

class RubocopApiStub
  def self.check_repo(_current_user, _repository, check)
    check.start!
    check.finish!
  end
end
