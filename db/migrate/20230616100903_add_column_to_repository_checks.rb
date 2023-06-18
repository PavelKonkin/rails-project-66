class AddColumnToRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    add_column :repository_checks, :commit_link, :string
    add_column :repository_checks, :error_count, :integer
  end
end
