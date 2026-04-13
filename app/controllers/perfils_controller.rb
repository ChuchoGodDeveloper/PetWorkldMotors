class PerfilsController < ApplicationController
  before_action :require_login
  before_action :set_perfil, only: [:show, :edit, :update, :destroy]

  def index
    if params[:q].present?
      @perfils = Perfil.where("strNombre_Perfil ILIKE ?", "%#{params[:q]}%")
    else
      @perfils = Perfil.all
    end
  end

  def show
  end

  def new
    @perfil = Perfil.new
  end

  def create
    @perfil = Perfil.new(perfil_params)
    if @perfil.save
      redirect_to perfils_path, notice: 'Perfil creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @perfil.update(perfil_params)
      redirect_to perfils_path, notice: 'Perfil actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @perfil.destroy
    redirect_to perfils_path, notice: 'Perfil eliminado exitosamente.'
  end

  private

  def set_perfil
    @perfil = Perfil.find(params[:id])
  end

  def perfil_params
    # Asegúrate de permitir los parámetros correctos según tu schema
    params.require(:perfil).permit(:strNombre_Perfil, :bitAdministrador)
  end
end