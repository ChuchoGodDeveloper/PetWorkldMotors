class ModulosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params[:q].present?
      @modulos = Modulo.where(Modulo.arel_table[:strNombreModulo].matches("%#{params[:q]}%")).page(params[:page]).per(5)
    else
      @modulos = Modulo.page(params[:page]).per(5)
    end
    
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

  def new
    @modulo = Modulo.new
  end

  def edit
    @modulo = Modulo.find(params[:id])
  end

  def create
    @modulo = Modulo.new(modulo_params)
    
    respond_to do |format|
      if @modulo.save
        format.html { redirect_to modulos_path, notice: 'Módulo creado exitosamente.' }
        format.json { render json: { success: true, modulo: @modulo }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @modulo.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @modulo = Modulo.find(params[:id])
    
    respond_to do |format|
      if @modulo.update(modulo_params)
        format.html { redirect_to modulos_path, notice: 'Módulo actualizado exitosamente.' }
        format.json { render json: { success: true, modulo: @modulo } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @modulo.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @modulo = Modulo.find(params[:id])
    @modulo.destroy
    
    respond_to do |format|
      format.html { redirect_to modulos_path, notice: 'Módulo eliminado exitosamente.' }
      format.json { render json: { success: true } }
    end
  end

  private

  def modulo_params
    params.require(:modulo).permit(:strNombreModulo)
  end
end