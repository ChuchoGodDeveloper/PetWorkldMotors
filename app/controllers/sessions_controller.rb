class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create] # Para Fetch API

  def new
    # Renderiza app/views/sessions/new.html.erb
  end

  def create
    usuario = Usuario.find_by(strNombreUsuario: params[:strNombreUsuario])

    if usuario && usuario.authenticate(params[:strPwd])
      if usuario.idEstado_Usuario == 1
        # Generar JWT
        token = JWT.encode({ usuario_id: usuario.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
        
        render json: { success: true, token: token, redirect_url: principal_path }, status: :ok
      else
        render json: { success: false, message: 'El usuario se encuentra inactivo.' }, status: :unauthorized
      end
    else
      render json: { success: false, message: 'Usuario o contraseña incorrectos.' }, status: :unauthorized
    end
  end
end