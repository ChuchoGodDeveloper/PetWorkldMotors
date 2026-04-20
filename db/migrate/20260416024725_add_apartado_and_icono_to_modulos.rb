class AddApartadoAndIconoToModulos < ActiveRecord::Migration[8.1]
  def change
    add_column :modulos, :apartado_id, :integer
    add_column :modulos, :strIcono_Modulo, :string
  end
end
