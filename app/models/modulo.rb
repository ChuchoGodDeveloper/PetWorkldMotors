class Modulo < ApplicationRecord
  has_many :permisos_perfils, foreign_key: 'idModulo', dependent: :destroy
  has_many :menus, foreign_key: 'idModulo', dependent: :destroy
  
  # Nueva relación
  belongs_to :apartado, optional: true

  validates :strNombreModulo, presence: true, uniqueness: true
end