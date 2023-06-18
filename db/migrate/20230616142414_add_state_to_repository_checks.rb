class AddStateToRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    add_column :repository_checks, :state, :string
  end
end
