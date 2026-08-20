<template>
  <div>
    <div class="space-y-6 animate-fade-in">

      <!-- Encabezado del Módulo -->
      <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Inventario de Materiales</h2>
          <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Consulta el stock disponible y los movimientos por año.
          </p>
        </div>

        <div class="flex gap-3 w-full sm:w-auto">
          <!-- Botón Nueva Entrada (Verde) -->
          <button @click="abrirEntrada()"
            class="flex-1 sm:flex-none cursor-pointer flex items-center justify-center gap-1.5 px-4 py-2 text-sm font-medium text-white rounded-full bg-gradient-to-t from-[#14a73e] to-[#66f771] shadow-[0_0.7em_1.5em_-0.5em_#14a73e98] hover:shadow-[0_0.5em_1.5em_-0.5em_#14a73e98] active:shadow-[0_0.3em_1em_-0.5em_#14a73e98] active:scale-95 transition-all duration-200"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
            </svg>
            Nueva Entrada
          </button>
          
          <!-- Botón Registrar Salida (Rojo) -->
          <button @click="abrirSalida()"
            class="flex-1 sm:flex-none cursor-pointer flex items-center justify-center gap-1.5 px-4 py-2 text-sm font-medium text-white rounded-full bg-gradient-to-t from-[#dc2626] to-[#f87171] shadow-[0_0.7em_1.5em_-0.5em_#dc262698] hover:shadow-[0_0.5em_1.5em_-0.5em_#dc262698] active:shadow-[0_0.3em_1em_-0.5em_#dc262698] active:scale-95 transition-all duration-200"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
            </svg>
            Registrar Salida
          </button>
        </div>
      </div>

      <!-- Buscador y Filtros -->
      <div
        class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm flex flex-col sm:flex-row gap-4 items-center">

        <!-- Input de Texto -->
        <div class="relative flex-1 w-full">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </div>
          <input v-model="busqueda" type="text" placeholder="Buscar material..."
            class="block w-full pl-10 pr-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm transition-colors">
        </div>

        <!-- Selector de Categoría -->
        <div class="w-full sm:w-56 shrink-0">
          <select v-model="filtroCategoria"
            class="block w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm transition-colors cursor-pointer">
            <option value="Todos">Todas las categorías</option>
            <option value="Oficina">Material de Oficina</option>
            <option value="Limpieza">Material de Limpieza</option>
          </select>
        </div>

        <!-- Selector de Año -->
        <div class="w-full sm:w-36 shrink-0">
          <select v-model="filtroAnio" @change="cargarInventario"
            class="block w-full px-3 py-2 border border-gray-300 dark:border-blue-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-blue-100 font-bold focus:outline-none focus:ring-2 focus:ring-blue-500 sm:text-sm transition-colors cursor-pointer">
            <option v-for="year in anosDisponibles" :key="year" :value="year">Año: {{ year }}</option>
          </select>
        </div>

      </div>

      <!-- Tabla de Inventario -->
      <div
        class="bg-white dark:bg-gray-800 shadow-sm rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-900/50">
              <tr>
                <th scope="col"
                  class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Imagen</th>
                <th scope="col"
                  class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Artículo</th>
                <th scope="col"
                  class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Tipo</th>
                <th scope="col"
                  class="px-6 py-3 text-center text-xs font-semibold text-blue-600 dark:text-blue-400 uppercase tracking-wider">
                  Entradas {{ filtroAnio }}</th>
                <th scope="col"
                  class="px-6 py-3 text-center text-xs font-semibold text-amber-600 dark:text-amber-400 uppercase tracking-wider">
                  Salidas {{ filtroAnio }}</th>
                <th scope="col"
                  class="px-6 py-3 text-center text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-wider">
                  Stock del año</th>
                <th scope="col"
                  class="px-6 py-3 text-center text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                  Acciones</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">

              <tr v-if="cargando">
                <td colspan="7" class="px-6 py-12 text-center">
                  <svg class="animate-spin h-8 w-8 text-blue-600 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none"
                    viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                    </path>
                  </svg>
                  <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">Calculando inventario de {{ filtroAnio }}...
                  </p>
                </td>
              </tr>

              <tr v-else-if="inventarioFiltrado.length === 0">
                <td colspan="7" class="px-6 py-12 text-center text-gray-500 dark:text-gray-400">
                  No se encontraron materiales que coincidan con los filtros.
                </td>
              </tr>

              <tr v-else v-for="item in inventarioFiltrado" :key="item.articulo_id" :id="`fila-${item.articulo_id}`"
                :class="[
                  'transition-all duration-700 ease-in-out',
                  ultimoModificado === item.articulo_id
                    ? 'bg-blue-100 dark:bg-blue-900/40 shadow-inner ring-2 ring-inset ring-blue-500'
                    : 'hover:bg-gray-50 dark:hover:bg-gray-700/50'
                ]">

                <td class="px-6 py-4 whitespace-nowrap">
                  <div @click="item.imagen_url ? abrirVistaPrevia(item.imagen_url) : null" :class="[
                    'h-10 w-10 flex-shrink-0 rounded-lg bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden border border-gray-200 dark:border-gray-600',
                    item.imagen_url ? 'cursor-pointer hover:opacity-80 hover:ring-2 hover:ring-blue-500 transition-all' : ''
                  ]" :title="item.imagen_url ? 'Clic para ampliar' : 'Sin imagen'">
                    <img v-if="item.imagen_url" :src="item.imagen_url" :alt="item.articulo"
                      class="h-full w-full object-cover" />
                    <svg v-else class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </td>

                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900 dark:text-white">{{ item.articulo }}</div>
                  <div class="text-xs text-gray-500 dark:text-gray-400">{{ item.medida }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="[
                    'text-xs font-medium px-2 py-0.5 rounded border transition-colors',
                    item.tipo === 'Oficina'
                      ? 'bg-blue-50 border-blue-200 text-blue-700 hover:bg-blue-100 dark:bg-blue-900/20 dark:border-blue-800 dark:text-blue-400'
                      : 'bg-gray-100 border-gray-200 text-gray-700 hover:bg-gray-200 hover:border-gray-300 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300 dark:hover:bg-gray-700'
                  ]">
                    {{ item.tipo }}
                  </span>
                </td>
                <td
                  class="px-6 py-4 whitespace-nowrap text-sm text-center font-medium text-blue-700 dark:text-blue-400">
                  {{ item.total_entradas }}
                </td>
                <td
                  class="px-6 py-4 whitespace-nowrap text-sm text-center font-medium text-amber-700 dark:text-amber-400">
                  {{ item.total_salidas }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-center bg-gray-50/50 dark:bg-gray-900/20">
                  <span
                    :class="['text-base font-black', item.stock_disponible <= 5 ? 'text-red-600 dark:text-red-400' : 'text-gray-900 dark:text-white']">
                    {{ item.stock_disponible }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <!-- Contenedor Flex para separar los botones -->
                  <div class="flex items-center justify-between gap-2">

                    <button @click="abrirEntrada(item)" title="Añadir Entrada"
                      class="cursor-pointer flex items-center justify-center gap-1.5 px-4 py-2 text-sm font-medium text-white rounded-full bg-gradient-to-t from-[#14a73e] to-[#66f771] shadow-[0_0.7em_1.5em_-0.5em_#14a73e98] hover:shadow-[0_0.5em_1.5em_-0.5em_#14a73e98] active:shadow-[0_0.3em_1em_-0.5em_#14a73e98] active:scale-95 transition-all duration-200">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                      </svg>

                    </button>

                    <button @click="abrirSalida(item)" title="Registrar Salida" :disabled="item.stock_disponible <= 0"
                      class="cursor-pointer flex items-center justify-center gap-1.5 px-4 py-2 text-sm font-medium text-white rounded-full bg-gradient-to-t from-[#dc2626] to-[#f87171] shadow-[0_0.7em_1.5em_-0.5em_#dc262698] hover:shadow-[0_0.5em_1.5em_-0.5em_#dc262698] active:shadow-[0_0.3em_1em_-0.5em_#dc262698] active:scale-95 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:active:scale-100 disabled:hover:shadow-[0_0.7em_1.5em_-0.5em_#dc262698]">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"></path>
                      </svg>

                    </button>

                  </div>
                </td>
              </tr>

            </tbody>
          </table>
        </div>
      </div>

    </div>

    <!-- Modales -->
    <EntradaMaterialModal :is-open="mostrarModalEntrada" :articulo-preseleccionado="articuloPreseleccionado"
      @close="cerrarModales" @saved="handleGuardado" />

    <SalidaMaterialModal :is-open="mostrarModalSalida" :inventario-actual="inventario"
      :articulo-preseleccionado="articuloPreseleccionado" @close="cerrarModales" @saved="handleGuardado" />

    <!-- Modal de Vista Previa de Imagen (Lightbox) -->
    <transition name="modal-fade">
      <div v-if="mostrarModalImagen"
        class="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm"
        @click.self="cerrarVistaPrevia">
        <div class="relative max-w-4xl max-h-[90vh] flex flex-col items-center justify-center">
          <button @click="cerrarVistaPrevia"
            class="absolute -top-12 right-0 text-white hover:text-gray-300 focus:outline-none transition-colors">
            <svg class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
          <img :src="imagenSeleccionada" class="max-w-full max-h-[85vh] object-contain rounded-lg shadow-2xl"
            @click.stop />
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
import EntradaMaterialModal from '@/components/EntradaMaterialModal.vue'
import SalidaMaterialModal from '@/components/SalidaMaterialModal.vue'

const toast = useToast()
const inventario = ref([])
const cargando = ref(true)

const hoy = new Date()
const anosDisponibles = [hoy.getFullYear() - 1, hoy.getFullYear(), hoy.getFullYear() + 1]
const filtroAnio = ref(hoy.getFullYear())

const busqueda = ref('')
const filtroCategoria = ref('Todos')

const mostrarModalEntrada = ref(false)
const mostrarModalSalida = ref(false)

const articuloPreseleccionado = ref('')
const ultimoModificado = ref(null)

const mostrarModalImagen = ref(false)
const imagenSeleccionada = ref(null)

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

const abrirEntrada = (item = null) => {
  articuloPreseleccionado.value = item ? item.articulo_id : ''
  mostrarModalEntrada.value = true
}

const abrirSalida = (item = null) => {
  articuloPreseleccionado.value = item ? item.articulo_id : ''
  mostrarModalSalida.value = true
}

const cerrarModales = () => {
  mostrarModalEntrada.value = false
  mostrarModalSalida.value = false
  articuloPreseleccionado.value = ''
}

const cargarInventario = async () => {
  cargando.value = true
  try {
    inventario.value = await inventarioService.obtenerInventarioPorAnio(filtroAnio.value)
  } catch (error) {
    console.error('Error al cargar el inventario:', error)
    toast.error('Ocurrió un error al cargar los datos del inventario.')
  } finally {
    cargando.value = false
  }
}

const handleGuardado = async () => {
  const idModificado = articuloPreseleccionado.value;
  ultimoModificado.value = idModificado;

  await cargarInventario();

  if (idModificado) {
    await nextTick();

    const fila = document.getElementById(`fila-${idModificado}`);
    if (fila) {
      fila.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    setTimeout(() => {
      if (ultimoModificado.value === idModificado) {
        ultimoModificado.value = null;
      }
    }, 3000);
  }
}

const inventarioFiltrado = computed(() => {
  let resultado = inventario.value

  if (filtroCategoria.value !== 'Todos') {
    resultado = resultado.filter(item => item.tipo === filtroCategoria.value)
  }

  if (busqueda.value) {
    const termino = busqueda.value.toLowerCase()
    resultado = resultado.filter(item =>
      item.articulo.toLowerCase().includes(termino)
    )
  }

  return resultado
})

// NUEVO: Manejo de teclado para cerrar el visor de imagen con 'Escape'
const manejarTeclado = (e) => {
  if (e.key === 'Escape' && mostrarModalImagen.value) {
    cerrarVistaPrevia()
  }
}

onMounted(() => {
  window.addEventListener('keydown', manejarTeclado)
  cargarInventario()
})

// NUEVO: Limpiamos el evento de teclado al desmontar el componente
onUnmounted(() => {
  window.removeEventListener('keydown', manejarTeclado)
})
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>