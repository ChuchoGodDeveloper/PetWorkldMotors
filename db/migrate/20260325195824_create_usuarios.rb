class CreateUsuarios < ActiveRecord::Migration[7.1]
  def change
    create_table :usuarios do |t|
      t.string :strNombreUsuario, null: false
      t.integer :idPerfil, null: false
      t.string :strPwd, null: false
      t.integer :idEstado_Usuario, default: 1, null: false # 1=activo, 0=inactivo
      t.string :strCorreo, null: false
      t.string :strNumeroCelular

      t.timestamps
    end
    
    add_foreign_key :usuarios, :perfils, column: :idPerfil
    add_index :usuarios, :idPerfil
  end
end