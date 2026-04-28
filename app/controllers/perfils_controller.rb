class PerfilsController < ApplicationController
  skip_before_action :verify_authenticity_token # Permitir peticiones Fetch

  # Filtros de seguridad para bloquear el acceso directo por URL
  before_action :verificar_permiso_editar, only: [:edit, :update]
  before_action :verificar_permiso_eliminar, only: [:destroy]

  def index
    if params[:q].present?
      # arel_table maneja automáticamente las comillas exactas que exige PostgreSQL
      @perfils = Perfil.where(Perfil.arel_table[:strNombre_Perfil].matches("%#{params[:q]}%")).page(params[:page]).per(5)
    else
      @perfils = Perfil.page(params[:page]).per(5)
    end
    
    respond_to do |format|
      format.html # Renderiza index.html.erb
      format.json { 
        render json: { 
          data: @perfils, 
          meta: { current_page: @perfils.current_page, total_pages: @perfils.total_pages } 
        } 
      }
    end
  end

  def show
    @perfil = Perfil.find(params[:id])
    render json: @perfil
  end

  # --- MÉTODOS PARA RENDERIZAR EL FORMULARIO HTML ---
  def new
    @perfil = Perfil.new
  end

  def edit
    @perfil = Perfil.find(params[:id])
  end

  # --- MÉTODOS ADAPTADOS PARA HTML Y JSON ---
  def create
    @perfil = Perfil.new(perfil_params)
    
    respond_to do |format|
      if @perfil.save
        format.html { redirect_to perfils_path, notice: 'Perfil creado exitosamente.' }
        format.json { render json: { success: true, perfil: @perfil }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @perfil.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @perfil = Perfil.find(params[:id])
    
    respond_to do |format|
      if @perfil.update(perfil_params)
        format.html { redirect_to perfils_path, notice: 'Perfil actualizado exitosamente.' }
        format.json { render json: { success: true, perfil: @perfil } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @perfil.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @perfil = Perfil.find(params[:id])
    @perfil.destroy
    
    respond_to do |format|
      format.html { redirect_to perfils_path, notice: 'Perfil eliminado exitosamente.' }
      format.json { render json: { success: true } }
    end
  end

  private

  def perfil_params
    params.require(:perfil).permit(:strNombre_Perfil, :bitAdministrador)
  end

  # --- MÉTODOS DE SEGURIDAD ---
  def verificar_permiso_editar
    unless tiene_permiso?('Perfils', :bitEditar)
      redirect_to perfils_path, alert: 'No tienes permiso para editar perfiles.'
    end
  end

  def verificar_permiso_eliminar
    unless tiene_permiso?('Perfils', :bitEliminar)
      redirect_to perfils_path, alert: 'No tienes permiso para eliminar perfiles.'
    end
  end
end