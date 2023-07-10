class RenameColumnsRepositoryCheck < ActiveRecord::Migration[7.0]
  def change
    rename_column :repository_checks, :state, :aasm_state
    rename_column :repository_checks, :check_pass, :passed
  end
end
