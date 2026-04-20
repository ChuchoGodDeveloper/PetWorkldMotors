class Apartado < ApplicationRecord
end
class Apartado < ApplicationRecord
  has_many :modulos, dependent: :nullify
  validates :strNombre_Apartado, presence: true, uniqueness: true
end