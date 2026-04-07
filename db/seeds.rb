# db/seeds.rb

# Módulos de Seguridad
m_perfil = Modulo.find_or_create_by!(strNombreModulo: 'Perfils')
m_modulo = Modulo.find_or_create_by!(strNombreModulo: 'Modulos')
m_permisos = Modulo.find_or_create_by!(strNombreModulo: 'Permisos_Perfils')
m_usuario = Modulo.find_or_create_by!(strNombreModulo: 'Usuarios')

# Módulos Principal 1 y 2 (Estáticos)
m_p1_1 = Modulo.find_or_create_by!(strNombreModulo: 'Principal 1.1')
m_p1_2 = Modulo.find_or_create_by!(strNombreModulo: 'Principal 1.2')
m_p2_1 = Modulo.find_or_create_by!(strNombreModulo: 'Principal 2.1')
m_p2_2 = Modulo.find_or_create_by!(strNombreModulo: 'Principal 2.2')

# Enlaces Menú (1: Seguridad, 2: Principal 1, 3: Principal 2)
Menu.find_or_create_by!(idMenu: 1, idModulo: m_perfil.id)
Menu.find_or_create_by!(idMenu: 1, idModulo: m_modulo.id)
Menu.find_or_create_by!(idMenu: 1, idModulo: m_permisos.id)
Menu.find_or_create_by!(idMenu: 1, idModulo: m_usuario.id)

Menu.find_or_create_by!(idMenu: 2, idModulo: m_p1_1.id)
Menu.find_or_create_by!(idMenu: 2, idModulo: m_p1_2.id)

Menu.find_or_create_by!(idMenu: 3, idModulo: m_p2_1.id)
Menu.find_or_create_by!(idMenu: 3, idModulo: m_p2_2.id)

puts "Módulos y Menús creados correctamente."

# Forzar la creación de un nuevo super admin para producción
# Forzar la creación de un nuevo super admin para producción
Usuario.find_or_create_by!(strNombreUsuario: 'superadmin') do |u|
  u.password = 'superadmin123'
  u.idPerfil = Perfil.find_or_create_by!(strNombrePerfil: 'Administrador').id
  u.idEstado_Usuario = 1
end

puts "Superadmin asegurado."