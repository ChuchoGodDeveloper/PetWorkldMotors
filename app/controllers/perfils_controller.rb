class PerfilsController < ApplicationController
  skip_before_action :verify_authenticity_token # Permitir peticiones Fetch

  def index
    if params[:q].present?
      @perfils = Perfil.where("strNombre_Perfil ILIKE ?", "%#{params[:q]}%").page(params[:page]).per(5)
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

  def create
    @perfil = Perfil.new(perfil_params)
    if @perfil.save
      render json: { success: true, perfil: @perfil }, status: :created
    else
      render json: { success: false, errors: @perfil.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @perfil = Perfil.find(params[:id])
    if @perfil.update(perfil_params)
      render json: { success: true, perfil: @perfil }
    else
      render json: { success: false, errors: @perfil.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @perfil = Perfil.find(params[:id])
    @perfil.destroy
    render json: { success: true }
  end

  private

  def perfil_params
    params.require(:perfil).permit(:strNombre_Perfil, :bitAdministrador)
  end
end