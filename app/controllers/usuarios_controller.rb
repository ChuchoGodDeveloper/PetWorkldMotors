class UsuariosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @usuarios = Usuario.includes(:perfil).page(params[:page]).per(5)
    
    usuarios_data = @usuarios.map do |u|
      {
        id: u.id,
        strNombreUsuario: u.strNombreUsuario,
        perfil: u.perfil ? u.perfil.strNombre_Perfil : '',
        estado: u.idEstado_Usuario == 1 ? 'Activo' : 'Inactivo',
        strCorreo: u.strCorreo,
        strNumeroCelular: u.strNumeroCelular,
        imagen_url: u.imagen_usuario.attached? ? url_for(u.imagen_usuario) : nil
      }
    end

    respond_to do |format|
      format.html
      format.json { 
        render json: { 
          data: usuarios_data, 
          meta: { current_page: @usuarios.current_page, total_pages: @usuarios.total_pages } 
        } 
      }
    end
  end

  def show
    @usuario = Usuario.find(params[:id])
    render json: {
      id: @usuario.id,
      strNombreUsuario: @usuario.strNombreUsuario,
      idPerfil: @usuario.idPerfil,
      idEstado_Usuario: @usuario.idEstado_Usuario,
      strCorreo: @usuario.strCorreo,
      strNumeroCelular: @usuario.strNumeroCelular
    }
  end

  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save
      render json: { success: true }, status: :created
    else
      render json: { success: false, errors: @usuario.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @usuario = Usuario.find(params[:id])
    upd_params = usuario_params
    upd_params.delete(:strPwd) if upd_params[:strPwd].blank?

    if @usuario.update(upd_params)
      render json: { success: true }
    else
      render json: { success: false, errors: @usuario.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy
    render json: { success: true }
  end

  private

  def usuario_params
    params.require(:usuario).permit(:strNombreUsuario, :idPerfil, :strPwd, :idEstado_Usuario, :strCorreo, :strNumeroCelular, :imagen_usuario)
  end
end