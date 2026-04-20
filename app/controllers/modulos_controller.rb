class ModulosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params[:q].present?
      @modulos = Modulo.includes(:apartado).where(Modulo.arel_table[:strNombreModulo].matches("%#{params[:q]}%")).page(params[:page]).per(5)
    else
      @modulos = Modulo.includes(:apartado).page(params[:page]).per(5)
    end
    
    respond_to do |format|
      format.html
      format.json { render json: { data: @modulos, meta: { current_page: @modulos.current_page, total_pages: @modulos.total_pages } } }
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
    gestionar_apartado_dinamico
    
    if @modulo.save
      redirect_to modulos_path, notice: 'Módulo creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @modulo = Modulo.find(params[:id])
    @modulo.assign_attributes(modulo_params)
    gestionar_apartado_dinamico
    
    if @modulo.save
      redirect_to modulos_path, notice: 'Módulo actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @modulo = Modulo.find(params[:id])
    @modulo.destroy
    redirect_to modulos_path, notice: 'Módulo eliminado exitosamente.'
  end

  private

  def modulo_params
    params.require(:modulo).permit(:strNombreModulo, :apartado_id, :strIcono_Modulo)
  end

  # Magia para crear apartados nuevos desde el mismo formulario
  def gestionar_apartado_dinamico
    if params[:nuevo_apartado_nombre].present?
      nuevo_apartado = Apartado.find_or_create_by(strNombre_Apartado: params[:nuevo_apartado_nombre]) do |a|
        a.strIcono_Apartado = params[:nuevo_apartado_icono] || 'fas fa-folder'
      end
      @modulo.apartado_id = nuevo_apartado.id
    end
  end
end