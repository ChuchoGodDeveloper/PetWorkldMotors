class ApplicationController < ActionController::Base
  helper_method :tiene_permiso?, :current_usuario

  def current_usuario
    # 1. Intenta por JWT (API)
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      begin
        decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
        return Usuario.find_by(id: decoded[0]['usuario_id'])
      rescue StandardError
        # Si el token expira o falla, lo ignora y busca la sesión
      end
    end
    
    # 2. Intenta por Sesión (Vistas HTML)
    Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id].present?
  end

  def tiene_permiso?(nombre_modulo, accion_columna)
    begin
      usuario = current_usuario
      return false unless usuario && usuario.respond_to?(:idPerfil) && usuario.idPerfil.present?

      modulo = Modulo.find_by(strNombreModulo: nombre_modulo)
      return false unless modulo

      permiso = PermisosPerfil.find_by(idPerfil: usuario.idPerfil, idModulo: modulo.id)
      return false unless permiso

      # Valida que el permiso sea true de forma segura (usando hash de atributos)
      permiso[accion_columna] == true
    rescue StandardError => e
      Rails.logger.error("Error validando permisos: #{e.message}")
      false 
    end
  end
end