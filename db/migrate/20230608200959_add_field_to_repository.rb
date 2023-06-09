class AddFieldToRepository < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :github_id, :string
  end
end
