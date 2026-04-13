class UsuariosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # Usamos includes(:perfil) para evitar consultas N+1 en la tabla
    @usuarios = Usuario.includes(:perfil)
    
    if params[:q].present?
      @usuarios = @usuarios.where(Usuario.arel_table[:strNombreUsuario].matches("%#{params[:q]}%"))
    end
    
    @usuarios = @usuarios.page(params[:page]).per(5)
    
    respond_to do |format|
      format.html
      format.json { 
        render json: { 
          data: @usuarios, 
          meta: { current_page: @usuarios.current_page, total_pages: @usuarios.total_pages } 
        } 
      }
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
    
    respond_to do |format|
      if @usuario.save
        format.html { redirect_to usuarios_path, notice: 'Usuario creado exitosamente.' }
        format.json { render json: { success: true, usuario: @usuario }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @usuario.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @usuario = Usuario.find(params[:id])
    
    # Evitar guardar contraseña en blanco si no la quieren cambiar al editar
    p = usuario_params
    p.delete(:strPwd) if p[:strPwd].blank?
    
    respond_to do |format|
      if @usuario.update(p)
        format.html { redirect_to usuarios_path, notice: 'Usuario actualizado exitosamente.' }
        format.json { render json: { success: true, usuario: @usuario } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @usuario.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy
    
    respond_to do |format|
      format.html { redirect_to usuarios_path, notice: 'Usuario eliminado exitosamente.' }
      format.json { render json: { success: true } }
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:strNombreUsuario, :idPerfil, :strPwd, :strCorreo, :strNumeroCelular, :idEstado_Usuario, :imagen_usuario)
  end
end