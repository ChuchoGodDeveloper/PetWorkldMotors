class PermisosPerfil < ApplicationRecord
  # Relaciones
  belongs_to :modulo, foreign_key: 'idModulo'
  belongs_to :perfil, foreign_key: 'idPerfil'

  # Validaciones
  validates :idPerfil, presence: true
  validates :idModulo, presence: true, uniqueness: { scope: :idPerfil, message: "ya tiene permisos asignados para este perfil" }
  validates :bitAgregar, :bitEditar, :bitConsulta, :bitEliminar, :bitDetalle, inclusion: { in: [true, false] }
end