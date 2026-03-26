class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.integer :idMenu, null: false
      t.integer :idModulo, null: false

      t.timestamps
    end
    
    add_foreign_key :menus, :modulos, column: :idModulo
    add_index :menus, :idModulo
  end
end