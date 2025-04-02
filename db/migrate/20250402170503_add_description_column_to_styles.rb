class AddDescriptionColumnToStyles < ActiveRecord::Migration[8.0]
  def change
    add_column :styles, :description, :string
  end
end
