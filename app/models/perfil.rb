class Perfil < ApplicationRecord
  has_many :usuarios, foreign_key: 'idPerfil', dependent: :destroy
  has_many :permisos_perfils, foreign_key: 'idPerfil', dependent: :destroy

  validates :strNombre_Perfil, presence: true, uniqueness: true
  validates :bitAdministrador, inclusion: { in: [true, false] }
end