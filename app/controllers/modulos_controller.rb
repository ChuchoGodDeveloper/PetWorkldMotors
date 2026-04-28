class ModulosController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  # Filtros de seguridad
  before_action :verificar_permiso_editar, only: [:edit, :update]
  before_action :verificar_permiso_eliminar, only: [:destroy]

  # ... aquí van tus métodos index, show, create, etc. ...

  private

  def verificar_permiso_editar
    unless tiene_permiso?('Modulos', :bitEditar)
      redirect_to modulos_path, alert: 'No tienes permiso para editar módulos.'
    end
  end

  def verificar_permiso_eliminar
    unless tiene_permiso?('Modulos', :bitEliminar)
      redirect_to modulos_path, alert: 'No tienes permiso para eliminar módulos.'
    end
  end
end