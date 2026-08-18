<template>
  <transition name="modal-fade">
    <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <!-- Modal ancho (max-w-5xl) para el diseño de 3 columnas -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-5xl overflow-hidden border border-gray-200 dark:border-gray-700 flex flex-col max-h-[90vh]">
        
        <!-- Encabezado -->
        <div class="px-6 py-5 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center bg-gray-50 dark:bg-gray-900/50 shrink-0">
          <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Registrar Salida de Material</h3>
          <button @click="cerrar" class="text-gray-400 hover:text-gray-500 focus:outline-none transition-colors">
            <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Cuerpo del Formulario con Scroll -->
        <form @submit.prevent="guardar" class="p-6 md:p-8 overflow-y-auto flex-1 flex flex-col">
          
          <!-- GRID DE 3 COLUMNAS -->
          <div class="grid grid-cols-1 md:grid-cols-[1fr_1.8fr_1fr] gap-8 flex-1">
            
            <!-- COLUMNA 1: Artículo e Imagen -->
            <div class="space-y-4 flex flex-col">
              <div>
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Artículo</label>
                <select 
                  v-model="formulario.articulo_id" 
                  required
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
                  <option value="" disabled>Seleccione un artículo...</option>
                  <option 
                    v-for="item in articulosDisponibles" 
                    :key="item.articulo_id" 
                    :value="item.articulo_id"
                  >
                    {{ item.articulo }} (Disp: {{ item.stock_disponible }})
                  </option>
                </select>
              </div>

              <!-- Contenedor de la Imagen Dinámica -->
              <div class="w-full aspect-square bg-gray-100 dark:bg-gray-900/50 rounded-xl border border-gray-200 dark:border-gray-700 flex items-center justify-center overflow-hidden shadow-inner">
                <img v-if="imagenArticuloSeleccionado" :src="imagenArticuloSeleccionado" class="w-full h-full object-cover transition-opacity duration-300" />
                <div v-else class="flex flex-col items-center justify-center text-gray-400">
                  <svg class="h-16 w-16 mb-2 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <span class="text-sm font-medium">Sin imagen</span>
                </div>
              </div>
            </div>

            <!-- COLUMNA 2: Detalles de la Transacción -->
            <div class="space-y-5 flex flex-col">
              
              <div>
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Área Solicitante</label>
                <select 
                  v-model="formulario.area_id" 
                  required
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
                  <option value="" disabled>Seleccione el área...</option>
                  <option v-for="area in areas" :key="area.id" :value="area.id">
                    {{ area.seccion }}
                  </option>
                </select>
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Cantidad</label>
                  <input 
                    type="number" 
                    v-model="formulario.cantidad" 
                    required 
                    min="1" 
                    :max="stockMaximo"
                    :disabled="!formulario.articulo_id"
                    class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors disabled:opacity-50"
                  >
                  <p v-if="formulario.articulo_id" class="text-xs text-blue-600 dark:text-blue-400 mt-1">
                    Máximo: {{ stockMaximo }}
                  </p>
                </div>
                
                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Tipo de Salida</label>
                  <select 
                    v-model="formulario.tipo_salida" 
                    required
                    class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                  >
                    <option value="Mensual">Dotación Mensual</option>
                    <option value="Vale">Vale Esporádico</option>
                  </select>
                </div>
              </div>

              <div v-if="formulario.tipo_salida === 'Vale'" class="animate-fade-in">
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Folio del Vale</label>
                <input 
                  type="text" 
                  v-model="formulario.folio_vale" 
                  required
                  placeholder="Ej. VALE-001"
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
              </div>

              <div>
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Fecha y Hora de Entrega</label>
                <input 
                  type="datetime-local" 
                  v-model="formulario.fecha_solicitud" 
                  required
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
              </div>

            </div>

            <!-- COLUMNA 3: Observaciones -->
            <div class="flex flex-col h-full">
              <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Observaciones</label>
              <textarea 
                v-model="formulario.observacion" 
                placeholder="Ej. Entrega incompleta por falta de stock..."
                class="w-full flex-1 px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors resize-none"
              ></textarea>
              <p class="text-sm text-gray-500 mt-2">Agrega notas o detalles relevantes a esta salida de material.</p>
            </div>

          </div>

          <!-- Botones de Acción (Base) -->
          <div class="pt-6 mt-8 border-t border-gray-200 dark:border-gray-700 flex gap-4 justify-end shrink-0">
            <button 
              type="button" 
              @click="cerrar"
              class="px-6 py-3 text-lg font-medium bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
            >
              Cancelar
            </button>
            <button 
              type="submit" 
              :disabled="guardando || !formulario.articulo_id"
              class="px-6 py-3 text-lg font-medium bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 disabled:opacity-50"
            >
              <svg v-if="guardando" class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ guardando ? 'Registrando...' : 'Registrar Salida' }}
            </button>
          </div>

        </form>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { inventarioService } from '@/services/inventarioService'
import { useToast } from '@/composables/useToast'

const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  },
  inventarioActual: {
    type: Array,
    default: () => []
  },
  articuloPreseleccionado: {
    type: [String, Number],
    default: ''
  }
})

const emit = defineEmits(['close', 'saved'])
const toast = useToast()

const areas = ref([])
const guardando = ref(false)

const obtenerFechaActualFormateada = () => {
  const ahora = new Date()
  ahora.setMinutes(ahora.getMinutes() - ahora.getTimezoneOffset())
  return ahora.toISOString().slice(0, 16)
}

const formularioBase = {
  articulo_id: '',
  area_id: '',
  cantidad: 1,
  tipo_salida: 'Mensual',
  folio_vale: '',
  fecha_solicitud: obtenerFechaActualFormateada(), 
  observacion: ''
}

const formulario = ref({ ...formularioBase })

// NUEVO: Buscamos la URL de la imagen basándonos en el artículo seleccionado desde el inventario actual
const imagenArticuloSeleccionado = computed(() => {
  if (!formulario.value.articulo_id) return null
  const articulo = props.inventarioActual.find(a => a.articulo_id === formulario.value.articulo_id)
  return articulo ? articulo.imagen_url : null
})

watch(() => props.isOpen, (nuevoValor) => {
  if (nuevoValor) {
    if (!formulario.value.fecha_solicitud) {
      formulario.value.fecha_solicitud = obtenerFechaActualFormateada()
    }
    
    if (props.articuloPreseleccionado) {
      formulario.value.articulo_id = props.articuloPreseleccionado
    } else {
      formulario.value.articulo_id = ''
    }
  }
})

const articulosDisponibles = computed(() => {
  return props.inventarioActual.filter(item => item.stock_disponible > 0)
})

const stockMaximo = computed(() => {
  if (!formulario.value.articulo_id) return 0
  const articulo = props.inventarioActual.find(a => a.articulo_id === formulario.value.articulo_id)
  return articulo ? articulo.stock_disponible : 0
})

watch(() => formulario.value.articulo_id, () => {
  if (formulario.value.cantidad > stockMaximo.value) {
    formulario.value.cantidad = stockMaximo.value
  }
})

const manejarTeclado = (e) => {
  if (e.key === 'Escape' && props.isOpen) {
    cerrar()
  }
}

onUnmounted(() => {
  window.removeEventListener('keydown', manejarTeclado)
})

onMounted(async () => {
  window.addEventListener('keydown', manejarTeclado)
  try {
    areas.value = await inventarioService.obtenerAreas()
  } catch (error) {
    toast.error('Error al cargar las áreas solicitantes')
  }
})

const cerrar = () => {
  formulario.value.articulo_id = ''
  formulario.value.cantidad = 1
  formulario.value.folio_vale = ''
  
  emit('close')
}

const guardar = async () => {
  if (formulario.value.cantidad > stockMaximo.value) {
    return toast.error(`No puedes entregar más de ${stockMaximo.value} unidades.`)
  }

  guardando.value = true
  try {
    const datosGuardar = {
      articulo_id: formulario.value.articulo_id,
      area_id: formulario.value.area_id,
      cantidad: formulario.value.cantidad,
      tipo_salida: formulario.value.tipo_salida,
      fecha_solicitud: formulario.value.fecha_solicitud,
      fecha_aprobacion: formulario.value.fecha_solicitud, 
      observacion: formulario.value.observacion || null
    }

    if (formulario.value.tipo_salida === 'Vale') {
      datosGuardar.folio_vale = formulario.value.folio_vale
    }

    await inventarioService.registrarSalida(datosGuardar)
    
    toast.success('Salida registrada correctamente')
    emit('saved') 
    cerrar()
  } catch (error) {
    console.error(error)
    toast.error('Ocurrió un error al registrar la salida')
  } finally {
    guardando.value = false
  }
}
</script>

<style scoped>
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}
.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}
.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>