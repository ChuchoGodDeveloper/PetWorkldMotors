class UsuariosController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  # Filtros de seguridad para bloquear el acceso directo por URL
  before_action :verificar_permiso_editar, only: [:edit, :update]
  before_action :verificar_permiso_eliminar, only: [:destroy]

  # --- MÉTODO PARA LA VISTA HOME ---
  def perfil_actual
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header.present?
    
    if token.present?
      begin
        decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
        usuario_id = decoded_token.first['usuario_id']
        usuario = Usuario.includes(:perfil).find_by(id: usuario_id)
        
        if usuario
          render json: {
            success: true,
            nombre: usuario.strNombreUsuario,
            correo: usuario.strCorreo,
            celular: usuario.strNumeroCelular.present? ? usuario.strNumeroCelular : 'No registrado',
            perfil: usuario.perfil&.strNombre_Perfil || 'Sin perfil asignado',
            estado: usuario.idEstado_Usuario == 1 ? 'Activo' : 'Inactivo',
            imagen_url: usuario.imagen_usuario.attached? ? url_for(usuario.imagen_usuario) : nil
          }, status: :ok
        else
          render json: { success: false, message: 'Usuario no encontrado.' }, status: :not_found
        end
      rescue StandardError => e
        render json: { success: false, message: 'Token inválido o expirado.' }, status: :unauthorized
      end
    else
      render json: { success: false, message: 'Falta el token.' }, status: :unauthorized
    end
  end
  # -----------------------------------------------

  def index
    @usuarios = Usuario.includes(:perfil)
    
    if params[:q].present?
      @usuarios = @usuarios.where(Usuario.arel_table[:strNombreUsuario].matches("%#{params[:q]}%"))
    end
    
    @usuarios = @usuarios.page(params[:page]).per(5)
    
    respond_to do |format|
      format.html
      format.json { render json: { data: @usuarios, meta: { current_page: @usuarios.current_page, total_pages: @usuarios.total_pages } } }
    end
  end

  def show
    @usuario = Usuario.find(params[:id])
    render json: @usuario
  end

  def new
    @usuario = Usuario.new
  end

  def edit
    @usuario = Usuario.find(params[:id])
  end

  def create
    @usuario = Usuario.new(usuario_params)

    if @usuario.save
      # Redirige a la página principal (Home)
      redirect_to principal_path, notice: 'Usuario creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @usuario = Usuario.find(params[:id])
    
    p = usuario_params
    p.delete(:strPwd) if p[:strPwd].blank?
    
    if @usuario.update(p)
      # Al actualizar, redirige directamente a la tabla
      redirect_to usuarios_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy
    
    redirect_to usuarios_path
  end

  private

  def usuario_params
    params.require(:usuario).permit(:strNombreUsuario, :idPerfil, :strPwd, :strCorreo, :strNumeroCelular, :idEstado_Usuario, :imagen_usuario)
  end

  # --- MÉTODOS DE SEGURIDAD ---
  def verificar_permiso_editar
    unless tiene_permiso?('Usuarios', :bitEditar)
      redirect_to usuarios_path, alert: 'No tienes permiso para editar usuarios.'
    end
  end

  def verificar_permiso_eliminar
    unless tiene_permiso?('Usuarios', :bitEliminar)
      redirect_to usuarios_path, alert: 'No tienes permiso para eliminar usuarios.'
    end
  end
end