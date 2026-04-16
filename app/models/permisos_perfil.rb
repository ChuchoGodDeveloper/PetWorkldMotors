<script>
document.addEventListener('DOMContentLoaded', () => {
  const token = localStorage.getItem('jwt_token');
  if (!token) window.location.replace('/login');

  // Llenar catálogos desde Ruby a JS
  const perfiles = <%= raw Perfil.all.select(:id, :strNombre_Perfil).to_json %>;
  const modulos = <%= raw Modulo.all.select(:id, :strNombreModulo).to_json %>;

  const selectPerfil = document.getElementById('idPerfil');
  const selectModulo = document.getElementById('idModulo');

  perfiles.forEach(p => selectPerfil.add(new Option(p.strNombre_Perfil, p.id)));
  modulos.forEach(m => selectModulo.add(new Option(m.strNombreModulo, m.id)));

  const tabla = document.getElementById('tabla-permisos');
  const form = document.getElementById('form-permisos');
  const btnCancelar = document.getElementById('btn-cancelar');

  const campos = {
    id: document.getElementById('permiso-id'),
    idPerfil: selectPerfil,
    idModulo: selectModulo,
    bitAgregar: document.getElementById('bitAgregar'),
    bitEditar: document.getElementById('bitEditar'),
    bitConsulta: document.getElementById('bitConsulta'),
    bitEliminar: document.getElementById('bitEliminar'),
    bitDetalle: document.getElementById('bitDetalle')
  };

  const cargarPermisos = async () => {
    try {
      // Tomamos el valor actual del select para filtrar
      const perfilId = campos.idPerfil.value;
      const url = perfilId ? `/permisos_perfils.json?perfil_id=${perfilId}` : '/permisos_perfils.json';
      
      const res = await fetch(url);
      const data = await res.json();
      
      tabla.innerHTML = '';
      data.forEach(permiso => {
        const tr = document.createElement('tr');
        tr.style.borderBottom = '1px solid #c9d0dabc';
        tr.innerHTML = `
          <td style="padding: 10px;">${permiso.perfil.strNombre_Perfil}</td>
          <td style="padding: 10px;">${permiso.modulo.strNombreModulo}</td>
          <td style="padding: 5px;">${permiso.bitAgregar ? '✔️' : '❌'}</td>
          <td style="padding: 5px;">${permiso.bitEditar ? '✔️' : '❌'}</td>
          <td style="padding: 5px;">${permiso.bitConsulta ? '✔️' : '❌'}</td>
          <td style="padding: 5px;">${permiso.bitEliminar ? '✔️' : '❌'}</td>
          <td style="padding: 5px;">${permiso.bitDetalle ? '✔️' : '❌'}</td>
          <td style="padding: 10px; text-align: center;">
            <button class="neo-button" style="padding: 5px 10px; font-size: 11px; width: auto;" onclick="editarPermiso(${permiso.id})">Editar</button>
            <button class="neo-button" style="padding: 5px 10px; font-size: 11px; width: auto; color: #ff4757;" onclick="eliminarPermiso(${permiso.id})">Eliminar</button>
          </td>
        `;
        tabla.appendChild(tr);
      });
    } catch (error) {
      console.error('Error:', error);
    }
  };

  // Escuchar cuando el usuario cambie el perfil en el select para recargar la tabla
  campos.idPerfil.addEventListener('change', cargarPermisos);

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = campos.id.value;
    const url = id ? `/permisos_perfils/${id}.json` : '/permisos_perfils.json';
    const method = id ? 'PUT' : 'POST';

    const payload = {
      permisos_perfil: {
        idPerfil: campos.idPerfil.value,
        idModulo: campos.idModulo.value,
        bitAgregar: campos.bitAgregar.checked,
        bitEditar: campos.bitEditar.checked,
        bitConsulta: campos.bitConsulta.checked,
        bitEliminar: campos.bitEliminar.checked,
        bitDetalle: campos.bitDetalle.checked
      }
    };

    try {
      const res = await fetch(url, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (res.ok) {
        // Guardamos el idPerfil actual antes de limpiar para no perder el filtro de la tabla
        const perfilActual = campos.idPerfil.value;
        limpiarFormulario();
        campos.idPerfil.value = perfilActual; // Restauramos la selección
        cargarPermisos();
      } else {
        const errorData = await res.json();
        const mensajes = errorData.errors ? errorData.errors.join('\n') : 'Error al guardar.';
        alert('No se pudo guardar:\n' + mensajes);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  });

  window.editarPermiso = async (id) => {
    try {
      const res = await fetch(`/permisos_perfils/${id}.json`);
      const permiso = await res.json();
      
      campos.id.value = permiso.id;
      campos.idPerfil.value = permiso.idPerfil;
      campos.idModulo.value = permiso.idModulo;
      campos.bitAgregar.checked = permiso.bitAgregar;
      campos.bitEditar.checked = permiso.bitEditar;
      campos.bitConsulta.checked = permiso.bitConsulta;
      campos.bitEliminar.checked = permiso.bitEliminar;
      campos.bitDetalle.checked = permiso.bitDetalle;
      
      btnCancelar.style.display = 'inline-block';
    } catch (error) {
      console.error('Error:', error);
    }
  };

  window.eliminarPermiso = async (id) => {
    if (!confirm('¿Seguro que deseas eliminar estos permisos?')) return;
    try {
      await fetch(`/permisos_perfils/${id}.json`, { method: 'DELETE' });
      cargarPermisos();
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const limpiarFormulario = () => {
    campos.id.value = '';
    campos.idPerfil.value = '';
    campos.idModulo.value = '';
    campos.bitAgregar.checked = false;
    campos.bitEditar.checked = false;
    campos.bitConsulta.checked = false;
    campos.bitEliminar.checked = false;
    campos.bitDetalle.checked = false;
    btnCancelar.style.display = 'none';
  };

  btnCancelar.addEventListener('click', limpiarFormulario);

  cargarPermisos();
});
</script>