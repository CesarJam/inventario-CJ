<template>
  <transition name="modal-fade">
    <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-lg overflow-hidden border border-gray-200 dark:border-gray-700">
        
        <!-- Encabezado -->
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center bg-gray-50 dark:bg-gray-900/50">
          <h3 class="text-lg font-bold text-gray-900 dark:text-white">Registrar Entrada de Material</h3>
          <button @click="cerrar" class="text-gray-400 hover:text-gray-500 focus:outline-none">
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Cuerpo del Formulario -->
        <form @submit.prevent="guardar" class="p-6 space-y-4">
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Artículo</label>
            <select 
              v-model="formulario.articulo_id" 
              required
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
              <option value="" disabled>Seleccione un artículo...</option>
              <option v-for="item in articulos" :key="item.id" :value="item.id">
                {{ item.articulo }} ({{ item.medida }})
              </option>
            </select>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Cantidad</label>
              <input 
                type="number" 
                v-model="formulario.cantidad" 
                required min="1"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
              >
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Tipo de Entrada</label>
              <select 
                v-model="formulario.tipo_entrada" 
                required
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
              >
                <option value="Stock Inicial">Stock Inicial (Anual)</option>
                <option value="Ingreso Esporádico">Ingreso Esporádico</option>
              </select>
            </div>
          </div>

          <!-- NUEVO CAMPO: Fecha y Hora Manual -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Fecha y Hora de Ingreso</label>
            <input 
              type="datetime-local" 
              v-model="formulario.fecha_entrada" 
              required
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
            <p class="text-xs text-gray-500 mt-1">Puedes modificarla si estás registrando material con retraso.</p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Observaciones (Opcional)</label>
            <textarea 
              v-model="formulario.observacion" 
              rows="2" 
              placeholder="Ej. Factura #123, Compra de urgencia..."
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
              :disabled="guardando"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 disabled:opacity-50"
            >
              <svg v-if="guardando" class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ guardando ? 'Guardando...' : 'Guardar Entrada' }}
            </button>
          </div>
        </form>

      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref, onMounted,onUnmounted, watch } from 'vue'
import { inventarioService } from '@/services/inventarioService'
import { useToast } from '@/composables/useToast'

const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  },
  articuloPreseleccionado: {
    type: [String, Number],
    default: ''
  }
})

const emit = defineEmits(['close', 'saved'])
const toast = useToast()

const articulos = ref([])
const guardando = ref(false)

const obtenerFechaActualFormateada = () => {
  const ahora = new Date()
  ahora.setMinutes(ahora.getMinutes() - ahora.getTimezoneOffset())
  return ahora.toISOString().slice(0, 16)
}

// Inicializamos el formulario reactivo
const formulario = ref({
  articulo_id: '',
  cantidad: 1,
  tipo_entrada: 'Ingreso Esporádico',
  fecha_entrada: obtenerFechaActualFormateada(), 
  observacion: ''
})

// MODIFICADO: Ya no reseteamos la fecha al abrir el modal, la conservamos
watch(() => props.isOpen, (nuevoValor) => {
  if (nuevoValor) {
    // Si por alguna razón la fecha está vacía, le ponemos la de hoy
    if (!formulario.value.fecha_entrada) {
      formulario.value.fecha_entrada = obtenerFechaActualFormateada()
    }
    
    // Si abrimos desde el botón de la fila, asignamos ese artículo
    if (props.articuloPreseleccionado) {
      formulario.value.articulo_id = props.articuloPreseleccionado
    }
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
    articulos.value = await inventarioService.obtenerArticulos()
  } catch (error) {
    toast.error('Error al cargar el catálogo de artículos')
  }
})

// MODIFICADO: Limpieza parcial para facturas/lotes
const cerrar = () => {
  // Solo limpiamos el artículo y reiniciamos la cantidad a 1.
  // Conservamos: fecha_entrada, tipo_entrada y observacion.
  formulario.value.articulo_id = ''
  formulario.value.cantidad = 1
  
  emit('close')
}

const guardar = async () => {
  guardando.value = true
  try {
    await inventarioService.registrarEntrada({
      articulo_id: formulario.value.articulo_id,
      cantidad: formulario.value.cantidad,
      tipo_entrada: formulario.value.tipo_entrada,
      fecha_entrada: formulario.value.fecha_entrada,
      observacion: formulario.value.observacion || null
    })
    
    toast.success('Entrada registrada correctamente')
    emit('saved') 
    cerrar() // Llama a la función que ahora conserva los datos base
  } catch (error) {
    console.error(error)
    toast.error('Ocurrió un error al guardar la entrada')
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
</style>