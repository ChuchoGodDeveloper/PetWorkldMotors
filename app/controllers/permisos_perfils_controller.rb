class PermisosPerfilsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @permisos = PermisosPerfil.includes(:perfil, :modulo).all
    
    respond_to do |format|
      format.html
      format.json { 
        render json: @permisos.as_json(include: {
          perfil: { only: [:id, :strNombre_Perfil] },
          modulo: { only: [:id, :strNombreModulo] }
        })
      }
    end
  end

  def show
    @permiso = PermisosPerfil.find(params[:id])
    render json: @permiso
  end

  def create
    @permiso = PermisosPerfil.new(permiso_params)
    if @permiso.save
      render json: { success: true, permiso: @permiso }, status: :created
    else
      render json: { success: false, errors: @permiso.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @permiso = PermisosPerfil.find(params[:id])
    if @permiso.update(permiso_params)
      render json: { success: true, permiso: @permiso }
    else
      render json: { success: false, errors: @permiso.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @permiso = PermisosPerfil.find(params[:id])
    @permiso.destroy
    render json: { success: true }
  end

  private

  def permiso_params
    params.require(:permisos_perfil).permit(:idModulo, :idPerfil, :bitAgregar, :bitEditar, :bitConsulta, :bitEliminar, :bitDetalle)
  end
end