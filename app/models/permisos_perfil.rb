class PermisosPerfil < ApplicationRecord
  # Relaciones
  belongs_to :modulo, foreign_key: 'idModulo'
  belongs_to :perfil, foreign_key: 'idPerfil'

  # Validaciones
  validates :idModulo, presence: true
  validates :idPerfil, presence: true
  validates :bitAgregar, :bitEditar, :bitConsulta, :bitEliminar, :bitDetalle, inclusion: { in: [true, false] }
end