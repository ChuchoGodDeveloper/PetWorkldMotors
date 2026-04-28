class ApplicationController < ActionController::Base
  helper_method :tiene_permiso?, :current_usuario

  def current_usuario
    # Intenta leer token JWT primero (para APIs)
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
        return Usuario.find_by(id: decoded[0]['usuario_id'])
      rescue JWT::DecodeError
        # Continuar para buscar en sesión si falla
      end
    end
    
    # Respaldo: Lee la cookie de sesión nativa de Rails (para las vistas HTML)
    Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end

  def tiene_permiso?(nombre_modulo, accion_columna)
    usuario = current_usuario
    return false unless usuario && usuario.idPerfil

    modulo = Modulo.find_by(strNombreModulo: nombre_modulo)
    return false unless modulo

    permiso = PermisosPerfil.find_by(idPerfil: usuario.idPerfil, idModulo: modulo.id)
    
    # Retorna true solo si el permiso existe y la columna específica es true
    permiso.present? && permiso.read_attribute(accion_columna) == true
  end
end