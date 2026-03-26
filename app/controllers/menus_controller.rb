class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def dinamico
    usuario = current_usuario
    unless usuario
      render json: { error: 'No autorizado' }, status: :unauthorized
      return
    end

    # Nombres de los menús principales según el requerimiento
    nombres_menus = { 1 => 'Seguridad', 2 => 'Principal 1', 3 => 'Principal 2' }
    
    # Filtrar solo los permisos del perfil del usuario que tengan al menos una acción en true
    permisos_activos = PermisosPerfil.includes(modulo: :menus).where(idPerfil: usuario.idPerfil).select do |p|
      p.bitAgregar || p.bitEditar || p.bitConsulta || p.bitEliminar || p.bitDetalle
    end

    menu_final = {}
    
    permisos_activos.each do |permiso|
      enlaces = Menu.where(idModulo: permiso.idModulo)
      enlaces.each do |enlace|
        nombre_padre = nombres_menus[enlace.idMenu]
        menu_final[nombre_padre] ||= []
        
        # Guardamos en localStorage los permisos en la vista, aquí solo armamos el árbol
        menu_final[nombre_padre] << {
          nombre: permiso.modulo.strNombreModulo,
          url: "/#{permiso.modulo.strNombreModulo.downcase.gsub('-', '_').parameterize}",
          permisos: {
            agregar: permiso.bitAgregar,
            editar: permiso.bitEditar,
            consulta: permiso.bitConsulta,
            eliminar: permiso.bitEliminar,
            detalle: permiso.bitDetalle
          }
        }
      end
    end

    render json: menu_final
  end
end