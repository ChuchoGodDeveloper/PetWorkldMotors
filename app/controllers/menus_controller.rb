class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def dinamico
    usuario = current_usuario
    unless usuario
      render json: { error: 'No autorizado' }, status: :unauthorized
      return
    end

    # Filtrar solo los permisos activos del perfil del usuario
    permisos_activos = PermisosPerfil.includes(modulo: :apartado).where(idPerfil: usuario.idPerfil).select do |p|
      p.bitAgregar || p.bitEditar || p.bitConsulta || p.bitEliminar || p.bitDetalle
    end

    menu_final = {}
    
    permisos_activos.each do |permiso|
      modulo = permiso.modulo
      next unless modulo # Seguridad extra por si hay datos huérfanos
      
      # Tomamos el apartado dinámico de la base de datos
      apartado = modulo.apartado
      nombre_padre = apartado ? apartado.strNombre_Apartado : 'Sin Categoría'
      icono_padre = apartado ? apartado.strIcono_Apartado : 'fas fa-folder'

      # Inicializamos el apartado en el JSON si no existe
      menu_final[nombre_padre] ||= { icono: icono_padre, modulos: [] }
      
      # Agregamos el módulo con su propio icono
      menu_final[nombre_padre][:modulos] << {
        nombre: modulo.strNombreModulo,
        url: "/#{modulo.strNombreModulo.downcase.gsub('-', '_').parameterize}",
        icono: modulo.strIcono_Modulo || 'fas fa-circle', # Icono por defecto si está vacío
        permisos: {
          agregar: permiso.bitAgregar,
          editar: permiso.bitEditar,
          consulta: permiso.bitConsulta,
          eliminar: permiso.bitEliminar,
          detalle: permiso.bitDetalle
        }
      }
    end

    render json: menu_final
  end
end