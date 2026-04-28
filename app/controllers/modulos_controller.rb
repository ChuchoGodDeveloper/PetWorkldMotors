class ModulosController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  # Bloqueos por URL antes de ejecutar la acción
  before_action -> { verificar_acceso('Modulos', :bitEditar) }, only: [:edit, :update]
  before_action -> { verificar_acceso('Modulos', :bitEliminar) }, only: [:destroy]

  # ... (resto de tus métodos index, show, new, create, etc. se quedan igual)

  private

  def verificar_acceso(nombre_modulo, accion_columna)
    unless tiene_permiso?(nombre_modulo, accion_columna)
      redirect_to modulos_path, alert: 'No tienes permiso para realizar esta acción.'
    end
  end

  # ... (modulo_params y gestionar_apartado_dinamico se quedan igual)
end