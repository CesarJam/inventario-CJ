<template>
  <transition name="modal-fade">
    <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <!-- Modal ancho (max-w-5xl) para acomodar las 3 columnas cómodamente -->
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-5xl overflow-hidden border border-gray-200 dark:border-gray-700 flex flex-col max-h-[90vh]">
        
        <!-- Encabezado -->
        <div class="px-6 py-5 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center bg-gray-50 dark:bg-gray-900/50 shrink-0">
          <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Registrar Entrada de Material</h3>
          <button @click="cerrar" class="text-gray-400 hover:text-gray-500 focus:outline-none transition-colors">
            <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Cuerpo del Formulario con Scroll si la pantalla es pequeña -->
        <form @submit.prevent="guardar" class="p-6 md:p-8 overflow-y-auto flex-1 flex flex-col">
          
          <!-- GRID DE 3 COLUMNAS -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8 flex-1">
            
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
                  <option v-for="item in articulos" :key="item.id" :value="item.id">
                    {{ item.articulo }} ({{ item.medida }})
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
            <div class="space-y-6 flex flex-col">
              <div>
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Cantidad</label>
                <input 
                  type="number" 
                  v-model="formulario.cantidad" 
                  required min="1"
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
              </div>
              <div>
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Tipo de Entrada</label>
                <select 
                  v-model="formulario.tipo_entrada" 
                  required
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
                  <option value="Stock Inicial">Stock Inicial (Anual)</option>
                  <option value="Ingreso Esporádico">Ingreso Esporádico</option>
                </select>
              </div>
              <div>
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Fecha y Hora</label>
                <input 
                  type="datetime-local" 
                  v-model="formulario.fecha_entrada" 
                  required
                  class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors"
                >
              </div>
            </div>

            <!-- COLUMNA 3: Observaciones -->
            <div class="flex flex-col h-full">
              <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Observaciones</label>
              
              <!-- Botones de Autocompletado -->
              <div class="flex flex-wrap gap-2 mb-3">
                <button 
                  type="button" 
                  @click="agregarTextoObservacion('Factura ')"
                  class="text-white bg-[#2557D6] hover:bg-[#2557D6]/90 focus:ring-4 focus:ring-[#2557D6]/50 box-border border border-transparent focus:outline-none font-medium leading-5 rounded-lg text-sm px-4 py-2.5 text-center inline-flex items-center dark:focus:ring-[#2557D6]/50 transition-colors"
                >
                  + Factura
                </button>
                <button 
                  type="button" 
                  @click="agregarTextoObservacion('Adquisiciones y servicios generales ')"
                  class="text-white bg-[#2557D6] hover:bg-[#2557D6]/90 focus:ring-4 focus:ring-[#2557D6]/50 box-border border border-transparent focus:outline-none font-medium leading-5 rounded-lg text-sm px-4 py-2.5 text-center inline-flex items-center dark:focus:ring-[#2557D6]/50 transition-colors"
                >
                  + Adquisiciones y servicios
                </button>
              </div>

              <!-- Referencia "observacionesInput" agregada -->
              <textarea 
                ref="observacionesInput"
                v-model="formulario.observacion" 
                placeholder="Ej. Factura #123, Compra de urgencia, material donado..."
                class="w-full flex-1 px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 focus:border-blue-500 transition-colors resize-none"
              ></textarea>
              <p class="text-sm text-gray-500 mt-2">Agrega notas o referencias relevantes al ingreso de este material.</p>
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
              :disabled="guardando"
              class="px-6 py-3 text-lg font-medium bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 disabled:opacity-50"
            >
              <svg v-if="guardando" class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ guardando ? 'Registrando...' : 'Guardar Entrada' }}
            </button>
          </div>

        </form>
      </div>
    </div>
  </transition>
</template>

<script setup>
// IMPORTANTE: Asegurarnos de importar 'nextTick'
import { ref, onMounted, onUnmounted, watch, computed, nextTick } from 'vue'
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

const observacionesInput = ref(null)

const obtenerFechaActualFormateada = () => {
  const ahora = new Date()
  ahora.setMinutes(ahora.getMinutes() - ahora.getTimezoneOffset())
  return ahora.toISOString().slice(0, 16)
}

const formulario = ref({
  articulo_id: '',
  cantidad: 1,
  tipo_entrada: 'Ingreso Esporádico',
  fecha_entrada: obtenerFechaActualFormateada(), 
  observacion: ''
})

const imagenArticuloSeleccionado = computed(() => {
  if (!formulario.value.articulo_id) return null
  const articuloEncontrado = articulos.value.find(a => a.id === formulario.value.articulo_id)
  return articuloEncontrado ? articuloEncontrado.imagen_url : null
})

// NUEVA FUNCIÓN: Agrega el texto y mueve el foco
const agregarTextoObservacion = async (texto) => {
  // Verificamos si ya hay texto para no pegar todo junto (agrega espacio si aplica)
  const actual = formulario.value.observacion || ''
  formulario.value.observacion = actual ? `${actual} ${texto}` : texto
  
  // Esperamos al siguiente renderizado del DOM de Vue
  await nextTick()
  
  // Ponemos el cursor en el textarea y lo movemos hasta el final
  if (observacionesInput.value) {
    observacionesInput.value.focus()
    const length = formulario.value.observacion.length
    observacionesInput.value.setSelectionRange(length, length)
  }
}

watch(() => props.isOpen, (nuevoValor) => {
  if (nuevoValor) {
    if (!formulario.value.fecha_entrada) {
      formulario.value.fecha_entrada = obtenerFechaActualFormateada()
    }
    
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
    articulos.value = await inventarioService.obtenerCatalogoCompleto()
  } catch (error) {
    toast.error('Error al cargar el catálogo de artículos')
  }
})

const cerrar = () => {
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
    cerrar() 
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