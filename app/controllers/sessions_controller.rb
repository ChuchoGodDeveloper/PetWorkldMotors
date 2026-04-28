class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create] # Para Fetch API

  def new
    # Renderiza app/views/sessions/new.html.erb
  end

  def create
    usuario = Usuario.find_by(strNombreUsuario: params[:strNombreUsuario])

    if usuario && usuario.authenticate(params[:strPwd])
      if usuario.idEstado_Usuario == 1
        # Generar JWT para peticiones Fetch/API
        token = JWT.encode({ usuario_id: usuario.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
        
        # LÍNEA AGREGADA: Guarda la sesión para que funcione 'current_usuario' en las vistas HTML
        session[:usuario_id] = usuario.id
        
        render json: { success: true, token: token, redirect_url: principal_path }, status: :ok
      else
        render json: { success: false, message: 'El usuario se encuentra inactivo.' }, status: :unauthorized
      end
    else
      render json: { success: false, message: 'Usuario o contraseña incorrectos.' }, status: :unauthorized
    end
  end
  
  # Asegúrate de tener tu método destroy para el Logout
  def destroy
    session[:usuario_id] = nil # Limpia la cookie de Rails
    # Aquí puedes manejar también la invalidación del JWT si la tienes implementada en el frontend
    redirect_to login_path, notice: "Sesión cerrada."
  end
end