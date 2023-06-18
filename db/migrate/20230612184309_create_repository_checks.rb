class CreateRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.boolean :check_pass, null: false, default: false
      t.string :commit_id
      t.json :check_result
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
