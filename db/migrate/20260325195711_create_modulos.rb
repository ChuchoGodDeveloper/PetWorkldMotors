class CreateModulos < ActiveRecord::Migration[7.1]
  def change
    create_table :modulos do |t|
      t.string :strNombreModulo, null: false

      t.timestamps
    end
  end
end