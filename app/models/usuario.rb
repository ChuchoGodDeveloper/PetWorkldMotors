class Usuario < ApplicationRecord
  require 'bcrypt'

  # Relaciones
  belongs_to :perfil, foreign_key: 'idPerfil'
  has_one_attached :imagen_usuario

  # Validaciones
  validates :strNombreUsuario, presence: true, uniqueness: true
  validates :idPerfil, presence: true
  validates :strCorreo, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :idEstado_Usuario, inclusion: { in: [0, 1] }
  validates :strPwd, presence: true, on: :create

  # Encriptación de contraseña al guardarla
  def strPwd=(new_password)
    @password = new_password
    self[:strPwd] = BCrypt::Password.create(new_password) if new_password.present?
  end

  # Método para verificar contraseña en el Login
  def authenticate(password_to_check)
    BCrypt::Password.new(self[:strPwd]) == password_to_check
  rescue BCrypt::Errors::InvalidHash
    false
  end
end