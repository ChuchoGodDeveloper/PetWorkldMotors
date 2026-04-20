class CreateApartados < ActiveRecord::Migration[8.1]
  def change
    create_table :apartados do |t|
      t.string :strNombre_Apartado
      t.string :strIcono_Apartado

      t.timestamps
    end
  end
end
