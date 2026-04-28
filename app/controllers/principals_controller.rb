class PrincipalsController < ApplicationController
  # Filtros de seguridad por URL evaluando :bitConsulta para cada módulo exacto
  before_action -> { verificar_permiso_consulta('Principal 1.1') }, only: [:p1_1]
  before_action -> { verificar_permiso_consulta('Principal 1.2') }, only: [:p1_2]
  before_action -> { verificar_permiso_consulta('Principal 2.1') }, only: [:p2_1]
  before_action -> { verificar_permiso_consulta('Principal 2.2') }, only: [:p2_2]

  def p1_1; end
  
  def p1_2; end
  
  def p2_1; end
  
  def p2_2; end

  private

  def verificar_permiso_consulta(nombre_modulo)
    unless tiene_permiso?(nombre_modulo, :bitConsulta)
      redirect_to principal_path, alert: "Acceso denegado. No tienes permiso para ver #{nombre_modulo}."
    end
  end
end