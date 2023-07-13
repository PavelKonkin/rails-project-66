# frozen_string_literal: true

class EslintApiStub
  def self.check_repo(_current_user, _repository, check)
    check.update(passed: true)
    check.start!
    check.finish!
  end
end
