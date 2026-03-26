class ModulosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @modulos = Modulo.page(params[:page]).per(5)
    
    respond_to do |format|
      format.html
      format.json { 
        render json: { 
          data: @modulos, 
          meta: { current_page: @modulos.current_page, total_pages: @modulos.total_pages } 
        } 
      }
    end
  end

  def show
    @modulo = Modulo.find(params[:id])
    render json: @modulo
  end

  def create
    @modulo = Modulo.new(modulo_params)
    if @modulo.save
      render json: { success: true, modulo: @modulo }, status: :created
    else
      render json: { success: false, errors: @modulo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @modulo = Modulo.find(params[:id])
    if @modulo.update(modulo_params)
      render json: { success: true, modulo: @modulo }
    else
      render json: { success: false, errors: @modulo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @modulo = Modulo.find(params[:id])
    @modulo.destroy
    render json: { success: true }
  end

  private

  def modulo_params
    params.require(:modulo).permit(:strNombreModulo)
  end
end