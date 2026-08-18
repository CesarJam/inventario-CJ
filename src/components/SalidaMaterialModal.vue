<template>
  <transition name="modal-fade">
    <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-lg overflow-hidden border border-gray-200 dark:border-gray-700">
        
        <!-- Encabezado -->
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center bg-gray-50 dark:bg-gray-900/50">
          <h3 class="text-lg font-bold text-gray-900 dark:text-white">Registrar Salida de Material</h3>
          <button @click="cerrar" class="text-gray-400 hover:text-gray-500 focus:outline-none">
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Cuerpo del Formulario -->
        <form @submit.prevent="guardar" class="p-6 space-y-4">
          
          <!-- Selección de Artículo (Solo muestra los que tienen stock) -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Artículo</label>
            <select 
              v-model="formulario.articulo_id" 
              required
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
              <option value="" disabled>Seleccione un artículo...</option>
              <option 
                v-for="item in articulosDisponibles" 
                :key="item.articulo_id" 
                :value="item.articulo_id"
              >
                {{ item.articulo }} (Disponibles: {{ item.stock_disponible }})
              </option>
            </select>
            <p v-if="formulario.articulo_id" class="text-xs text-blue-600 mt-1">
              Stock máximo permitido para entrega: {{ stockMaximo }}
            </p>
          </div>

          <!-- Selección de Área -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Área Solicitante</label>
            <select 
              v-model="formulario.area_id" 
              required
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
              <option value="" disabled>Seleccione el área...</option>
              <option v-for="area in areas" :key="area.id" :value="area.id">
                {{ area.seccion }}
              </option>
            </select>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <!-- Cantidad con límite dinámico -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Cantidad</label>
              <input 
                type="number" 
                v-model="formulario.cantidad" 
                required 
                min="1" 
                :max="stockMaximo"
                :disabled="!formulario.articulo_id"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors disabled:opacity-50"
              >
            </div>
            
            <!-- Tipo de Salida -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Tipo de Salida</label>
              <select 
                v-model="formulario.tipo_salida" 
                required
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
              >
                <option value="Mensual">Dotación Mensual</option>
                <option value="Vale">Vale Esporádico</option>
              </select>
            </div>
          </div>

          <!-- Folio del Vale (Condicional) -->
          <div v-if="formulario.tipo_salida === 'Vale'" class="animate-fade-in">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Folio del Vale</label>
            <input 
              type="text" 
              v-model="formulario.folio_vale" 
              required
              placeholder="Ej. VALE-001"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
          </div>

          <!-- NUEVO CAMPO: Fecha y Hora Manual -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Fecha y Hora de Entrega</label>
            <input 
              type="datetime-local" 
              v-model="formulario.fecha_solicitud" 
              required
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
            <p class="text-xs text-gray-500 mt-1">Puedes modificarla si estás registrando una entrega atrasada.</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Observaciones (Opcional)</label>
            <textarea 
              v-model="formulario.observacion" 
              rows="2" 
              placeholder="Ej. Entrega incompleta por falta de stock..."
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            ></textarea>
          </div>

          <!-- Botones de Acción -->
          <div class="pt-4 flex gap-3 justify-end">
            <button 
              type="button" 
              @click="cerrar"
              class="px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
            >
              Cancelar
            </button>
            <button 
              type="submit" 
              :disabled="guardando || !formulario.articulo_id"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 disabled:opacity-50"
            >
              <svg v-if="guardando" class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
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
  // ¡FALTABA ESTO! Prop para recibir el artículo de la tabla
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

// MODIFICADO: Asignar el artículo preseleccionado cuando se abre
watch(() => props.isOpen, (nuevoValor) => {
  if (nuevoValor) {
    // Si la fecha está vacía, ponemos la de hoy
    if (!formulario.value.fecha_solicitud) {
      formulario.value.fecha_solicitud = obtenerFechaActualFormateada()
    }
    
    // Asignar el ID que viene desde la tabla
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
    // ¡CORREGIDO! Carga dinámica de áreas
    areas.value = await inventarioService.obtenerAreas()
  } catch (error) {
    toast.error('Error al cargar las áreas solicitantes')
  }
})

const cerrar = () => {
  // Limpieza parcial para conservar datos útiles entre registros
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