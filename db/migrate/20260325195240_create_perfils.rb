class CreatePerfils < ActiveRecord::Migration[7.1] # El número de versión depende de tu Rails
  def change
    create_table :perfils do |t|
      t.string :strNombre_Perfil, null: false
      t.boolean :bitAdministrador, null: false, default: false

      t.timestamps
    end
  end
end