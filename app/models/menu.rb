class Menu < ApplicationRecord
  # Relaciones
  belongs_to :modulo, foreign_key: 'idModulo'

  # Validaciones
  validates :idMenu, presence: true
  validates :idModulo, presence: true
end