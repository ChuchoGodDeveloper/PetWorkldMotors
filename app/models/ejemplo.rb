class Usuario < ApplicationRecord
  # Provee métodos para fijar y autenticar contraseñas usando BCrypt
  has_secure_password

  # Validaciones de integridad del lado del servidor para evitar datos corruptos
  validates :strCorreo, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :strNombreUsuario, presence: true, length: { minimum: 3 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }
end