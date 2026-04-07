# db/seeds.rb

# 1. Crear/Asegurar Módulos
modulos_nombres = ['Perfils', 'Modulos', 'Permisos_Perfils', 'Usuarios', 'Principal 1.1', 'Principal 1.2', 'Principal 2.1', 'Principal 2.2']
modulos_objetos = modulos_nombres.map do |nombre|
  Modulo.find_or_create_by!(strNombreModulo: nombre)
end

# 2. Asegurar Perfil Administrador
perfil_admin = Perfil.find_or_create_by!(strNombre_Perfil: 'Administrador') do |p|
  p.bitAdministrador = true
end

# 3. Asignar TODOS los permisos al perfil Administrador para cada módulo
modulos_objetos.each do |mod|
  permiso = PermisosPerfil.find_or_initialize_by(idModulo: mod.id, idPerfil: perfil_admin.id)
  permiso.update!(
    bitAgregar: true,
    bitConsulta: true,
    bitDetalle: true,
    bitEditar: true,
    bitEliminar: true
  )
end

# 4. Asegurar Menús (ejemplo básico basado en tu lógica anterior)
[1, 2, 3].each do |id_m|
  # Relacionar algunos módulos a menús si no existen
  Menu.find_or_create_by!(idMenu: id_m, idModulo: modulos_objetos.first.id)
end

# 5. Asegurar Usuario Superadmin
Usuario.find_or_create_by!(strNombreUsuario: 'superadmin') do |u|
  u.strCorreo = 'superadmin@petworld.com'
  u.strPwd = 'superadmin123'
  u.idPerfil = perfil_admin.id
  u.idEstado_Usuario = 1
end

puts "Permisos totales asignados al Administrador y Superadmin actualizado."