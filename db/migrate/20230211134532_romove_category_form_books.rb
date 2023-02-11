class RomoveCategoryFormBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :category, :string
  end
end
