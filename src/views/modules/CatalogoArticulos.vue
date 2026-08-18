<template>
  <div class="space-y-6 animate-fade-in">
    
    <!-- Encabezado y Botones Principales -->
    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
      <div>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Catálogo de Artículos</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Gestiona los productos base del sistema con imágenes.
        </p>
      </div>
      
      <!-- Controles Superiores: Exportación y Nuevo -->
      <div class="flex flex-wrap items-center gap-3 w-full md:w-auto">
        <div class="flex gap-2">
          <button @click="exportarCSV" :disabled="articulosFiltrados.length === 0" class="flex items-center gap-1.5 px-3 py-2 bg-green-50 text-green-700 border border-green-200 hover:bg-green-100 dark:bg-green-900/30 dark:text-green-400 dark:border-green-800 rounded-lg text-sm font-medium transition-colors disabled:opacity-50" title="Exportar a Excel (CSV)">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
            CSV
          </button>
          <button @click="exportarPDF" :disabled="articulosFiltrados.length === 0" class="flex items-center gap-1.5 px-3 py-2 bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 dark:bg-red-900/30 dark:text-red-400 dark:border-red-800 rounded-lg text-sm font-medium transition-colors disabled:opacity-50" title="Descargar PDF">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
            PDF
          </button>
        </div>

        <button @click="abrirModalNuevo" class="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition-colors shadow-sm ml-auto md:ml-0">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
          Nuevo Artículo
        </button>
      </div>
    </div>

    <!-- Buscador y Filtros -->
    <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm flex flex-col sm:flex-row gap-4 items-center">
      <div class="relative flex-1 w-full">
        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
          <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
        </div>
        <input v-model="busqueda" type="text" placeholder="Buscar por nombre..." class="block w-full pl-10 pr-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm transition-colors">
      </div>
      <div class="w-full sm:w-56 shrink-0">
        <select v-model="filtroCategoria" class="block w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm transition-colors cursor-pointer">
          <option value="Todos">Todas las categorías</option>
          <option value="Oficina">Material de Oficina</option>
          <option value="Limpieza">Material de Limpieza</option>
        </select>
      </div>
    </div>

    <!-- Tabla -->
    <div class="bg-white dark:bg-gray-800 shadow-sm rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-900/50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Imagen</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Nombre del Artículo</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Medida</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Categoría</th>
              <th class="px-6 py-3 text-right text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
            <tr v-if="cargando">
              <td colspan="5" class="px-6 py-12 text-center text-sm text-gray-500">Cargando catálogo...</td>
            </tr>
            <tr v-else-if="articulosFiltrados.length === 0">
              <td colspan="5" class="px-6 py-12 text-center text-sm text-gray-500">No se encontraron artículos que coincidan con los filtros.</td>
            </tr>
            
            <tr v-else v-for="item in articulosFiltrados" :key="item.id" 
                :id="`fila-${item.id}`"
                :class="[
                  'transition-all duration-700 ease-in-out', 
                  ultimoModificado === item.id 
                    ? 'bg-blue-100 dark:bg-blue-900/40 shadow-inner ring-2 ring-inset ring-blue-500' 
                    : 'hover:bg-gray-50 dark:hover:bg-gray-700/50'
                ]">
              
              <!-- COLUMNA DE IMAGEN CON CLIC PARA AGRANDAR -->
              <td class="px-6 py-4 whitespace-nowrap">
                <div 
                  @click="item.imagen_url ? abrirVistaPrevia(item.imagen_url) : null"
                  :class="[
                    'h-10 w-10 flex-shrink-0 rounded-lg bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden border border-gray-200 dark:border-gray-600',
                    item.imagen_url ? 'cursor-pointer hover:opacity-80 hover:ring-2 hover:ring-blue-500 transition-all' : ''
                  ]"
                  :title="item.imagen_url ? 'Clic para ampliar' : 'Sin imagen'"
                >
                  <img v-if="item.imagen_url" :src="item.imagen_url" :alt="item.articulo" class="h-full w-full object-cover" />
                  <svg v-else class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                </div>
              </td>

              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">{{ item.articulo }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">{{ item.medida }}</td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="['px-2.5 py-1 inline-flex text-xs leading-5 font-semibold rounded-full', item.tipo === 'Oficina' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' : 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400']">
                  {{ item.tipo }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <button @click="abrirModalEditar(item)" class="text-blue-600 hover:text-blue-900 dark:text-blue-400 dark:hover:text-blue-300 mr-4">Editar</button>
                <button @click="confirmarEliminacion(item.id)" class="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300">Eliminar</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Integrado para Crear/Editar -->
    <transition name="modal-fade">
      <div v-if="mostrarModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-md overflow-hidden border border-gray-200 dark:border-gray-700">
          
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50 flex justify-between items-center">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">
              {{ esEdicion ? 'Editar Artículo' : 'Nuevo Artículo' }}
            </h3>
            <button @click="cerrarModal" class="text-gray-400 hover:text-gray-500">
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
          </div>

          <form @submit.prevent="guardar" class="p-6 space-y-4">
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Foto del Producto (Opcional)</label>
              <div class="flex items-center gap-4">
                <div class="h-16 w-16 flex-shrink-0 rounded-lg bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden border border-gray-300 dark:border-gray-600">
                  <img v-if="vistaPreviaImagen" :src="vistaPreviaImagen" class="h-full w-full object-cover" />
                  <svg v-else class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                </div>
                <input type="file" accept="image/*" @change="manejarArchivo" class="block w-full text-sm text-gray-500 dark:text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 dark:file:bg-blue-900/30 dark:file:text-blue-400 cursor-pointer">
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nombre del Artículo</label>
              <input v-model="formulario.articulo" type="text" required placeholder="Ej. Lápiz Adhesivo" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Unidad de Medida</label>
              <input v-model="formulario.medida" type="text" required placeholder="Ej. Pieza, Caja con 12, Paquete..." class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Categoría / Tipo</label>
              <select v-model="formulario.tipo" required class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                <option value="Oficina">Material de Oficina</option>
                <option value="Limpieza">Material de Limpieza</option>
              </select>
            </div>

            <div class="pt-4 flex gap-3 justify-end">
              <button type="button" @click="cerrarModal" class="px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 rounded-lg hover:bg-gray-50 transition-colors">Cancelar</button>
              <button type="submit" :disabled="guardando" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                <span v-if="guardando" class="flex items-center gap-2">
                  <svg class="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                  Procesando...
                </span>
                <span v-else>Guardar</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </transition>

    <!-- Modal de Vista Previa de Imagen (Lightbox) -->
    <transition name="modal-fade">
      <div v-if="mostrarModalImagen" class="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm" @click.self="cerrarVistaPrevia">
        <div class="relative max-w-4xl max-h-[90vh] flex flex-col items-center justify-center">
          <!-- Botón de Cerrar (Equis) -->
          <button @click="cerrarVistaPrevia" class="absolute -top-12 right-0 text-white hover:text-gray-300 focus:outline-none transition-colors">
            <svg class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
          
          <!-- Imagen Agrandada -->
          <img :src="imagenSeleccionada" class="max-w-full max-h-[85vh] object-contain rounded-lg shadow-2xl" @click.stop />
        </div>
      </div>
    </transition>

  </div>
</template>

<script setup>
// MODIFICADO: Importar onUnmounted
import { ref, onMounted, onUnmounted, computed, nextTick } from 'vue'
import { inventarioService } from '@/services/inventarioService'
import { useToast } from '@/composables/useToast'
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

const toast = useToast()
const articulos = ref([])
const cargando = ref(true)

const busqueda = ref('')
const filtroCategoria = ref('Oficina')

const ultimoModificado = ref(null)

// Estados del Modal Formulario y Archivos
const mostrarModal = ref(false)
const esEdicion = ref(false)
const guardando = ref(false)
const archivoSeleccionado = ref(null)
const vistaPreviaImagen = ref(null)

// Estados del Visor de Imagen (Lightbox)
const mostrarModalImagen = ref(false)
const imagenSeleccionada = ref(null)

const formularioBase = { id: null, articulo: '', medida: '', tipo: 'Oficina', imagen_url: null }
const formulario = ref({ ...formularioBase })

const articulosFiltrados = computed(() => {
  let resultado = articulos.value
  if (filtroCategoria.value !== 'Todos') {
    resultado = resultado.filter(item => item.tipo === filtroCategoria.value)
  }
  if (busqueda.value) {
    const termino = busqueda.value.toLowerCase()
    resultado = resultado.filter(item => item.articulo.toLowerCase().includes(termino))
  }
  return resultado
})

const cargarDatos = async () => {
  cargando.value = true
  try {
    articulos.value = await inventarioService.obtenerCatalogoCompleto()
  } catch (error) {
    toast.error('Error al cargar los artículos')
  } finally {
    cargando.value = false
  }
}

// === LÓGICA DEL VISOR DE IMAGEN ===
const abrirVistaPrevia = (url) => {
  imagenSeleccionada.value = url
  mostrarModalImagen.value = true
}

const cerrarVistaPrevia = () => {
  mostrarModalImagen.value = false
  setTimeout(() => {
    imagenSeleccionada.value = null
  }, 300)
}

// === MANEJO DE IMÁGENES AL CREAR/EDITAR ===
const manejarArchivo = (event) => {
  const file = event.target.files[0]
  if (file) {
    archivoSeleccionado.value = file
    vistaPreviaImagen.value = URL.createObjectURL(file)
  }
}

const abrirModalNuevo = () => {
  esEdicion.value = false
  formulario.value = { ...formularioBase }
  archivoSeleccionado.value = null
  vistaPreviaImagen.value = null
  mostrarModal.value = true
}

const abrirModalEditar = (item) => {
  esEdicion.value = true
  formulario.value = { ...item }
  archivoSeleccionado.value = null
  vistaPreviaImagen.value = item.imagen_url || null
  mostrarModal.value = true
}

const cerrarModal = () => {
  mostrarModal.value = false
  setTimeout(() => {
    formulario.value = { ...formularioBase }
    archivoSeleccionado.value = null
    vistaPreviaImagen.value = null
  }, 300)
}

const guardar = async () => {
  guardando.value = true
  
  let nombreArticuloGuardado = formulario.value.articulo;
  let idAfectado = formulario.value.id;

  try {
    if (archivoSeleccionado.value) {
      toast.info('Subiendo imagen, por favor espera...')
      const urlPublica = await inventarioService.subirImagen(archivoSeleccionado.value)
      formulario.value.imagen_url = urlPublica
    }

    if (esEdicion.value) {
      const { id, ...datosUpdate } = formulario.value
      await inventarioService.actualizarArticulo(id, datosUpdate)
      toast.success('Artículo actualizado correctamente')
    } else {
      const { id, ...datosInsert } = formulario.value
      await inventarioService.guardarArticulo(datosInsert)
      toast.success('Artículo agregado al catálogo')
    }
    
    cerrarModal()
    await cargarDatos()

    if (!idAfectado) {
      const nuevoItem = articulos.value.find(a => a.articulo === nombreArticuloGuardado);
      if (nuevoItem) idAfectado = nuevoItem.id;
    }

    if (idAfectado) {
      ultimoModificado.value = idAfectado;
      
      await nextTick(); 
      const fila = document.getElementById(`fila-${idAfectado}`);
      
      if (fila) {
        fila.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }

      setTimeout(() => {
        if (ultimoModificado.value === idAfectado) {
          ultimoModificado.value = null;
        }
      }, 1000);
    }

  } catch (error) {
    console.error(error)
    toast.error('Ocurrió un error al guardar')
  } finally {
    guardando.value = false
  }
}

const confirmarEliminacion = async (id) => {
  if (!window.confirm('¿Estás seguro de eliminar este artículo? Si ya tiene entradas/salidas registradas, podría generar errores en el historial.')) return

  try {
    await inventarioService.eliminarArticulo(id)
    toast.success('Artículo eliminado')
    await cargarDatos()
  } catch (error) {
    toast.error('No se puede eliminar porque ya está en uso en el inventario')
  }
}

// === EXPORTACIÓN CSV/PDF ===
const exportarCSV = () => {
  if (articulosFiltrados.value.length === 0) return toast.info('No hay datos para exportar')
  const encabezados = ['Articulo', 'Medida', 'Categoria']
  const filas = articulosFiltrados.value.map(i => [i.articulo, i.medida, i.tipo])
  let csvContent = "\uFEFF" + encabezados.join(";") + "\n"
  filas.forEach(fila => {
    let filaFormateada = fila.map(campo => `"${String(campo).replace(/"/g, '""')}"`).join(";")
    csvContent += filaFormateada + "\n"
  })
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement("a")
  const url = URL.createObjectURL(blob)
  link.setAttribute("href", url)
  link.setAttribute("download", `Catalogo_Articulos_${new Date().toISOString().split('T')[0]}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)
}

const exportarPDF = () => {
  if (articulosFiltrados.value.length === 0) return toast.info('No hay datos para exportar')
  const doc = new jsPDF()
  const fechaActualFormateada = new Date().toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
  doc.setFontSize(16)
  doc.setTextColor(31, 41, 55)
  doc.text('Catálogo General de Artículos', 14, 15)
  doc.setFontSize(10)
  doc.setTextColor(107, 114, 128)
  doc.text(`Generado el: ${fechaActualFormateada}`, 14, 22)
  doc.text(`Filtro aplicado: ${filtroCategoria.value}`, 14, 27)
  const columnas = [['Nombre del Artículo', 'Medida', 'Categoría']]
  const filas = articulosFiltrados.value.map(i => [i.articulo, i.medida, i.tipo])
  autoTable(doc, {
    head: columnas, body: filas, startY: 32, styles: { fontSize: 9, cellPadding: 3 },
    headStyles: { fillColor: [37, 99, 235], textColor: [255, 255, 255], fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [249, 250, 251] }, margin: { top: 32 }
  })
  doc.save(`Catalogo_Articulos_${new Date().toISOString().split('T')[0]}.pdf`)
}

// NUEVO: Manejo de teclado para cerrar modales con 'Escape'
const manejarTeclado = (e) => {
  if (e.key === 'Escape') {
    if (mostrarModalImagen.value) {
      cerrarVistaPrevia()
    } else if (mostrarModal.value) {
      cerrarModal()
    }
  }
}

onMounted(() => {
  window.addEventListener('keydown', manejarTeclado)
  cargarDatos()
})

// NUEVO: Limpiamos el evento de teclado al desmontar el componente
onUnmounted(() => {
  window.removeEventListener('keydown', manejarTeclado)
})
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s ease-in-out; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity 0.3s ease; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
</style>