class CreatePermisosPerfils < ActiveRecord::Migration[7.1]
  def change
    create_table :permisos_perfils do |t|
      t.integer :idModulo, null: false
      t.integer :idPerfil, null: false
      t.boolean :bitAgregar, default: false, null: false
      t.boolean :bitEditar, default: false, null: false
      t.boolean :bitConsulta, default: false, null: false
      t.boolean :bitEliminar, default: false, null: false
      t.boolean :bitDetalle, default: false, null: false

      t.timestamps
    end
    
    add_foreign_key :permisos_perfils, :modulos, column: :idModulo
    add_foreign_key :permisos_perfils, :perfils, column: :idPerfil
    add_index :permisos_perfils, :idModulo
    add_index :permisos_perfils, :idPerfil
  end
end