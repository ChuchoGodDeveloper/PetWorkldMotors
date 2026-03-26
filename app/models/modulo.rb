class Modulo < ApplicationRecord
  has_many :permisos_perfils, foreign_key: 'idModulo', dependent: :destroy
  has_many :menus, foreign_key: 'idModulo', dependent: :destroy

  validates :strNombreModulo, presence: true, uniqueness: true
end