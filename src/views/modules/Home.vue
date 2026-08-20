<template>
  <div class="space-y-6 animate-fade-in">
    
    <!-- Saludo y Encabezado -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
      <div>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Panel de Control</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Resumen de actividad correspondiente a <span class="font-semibold text-blue-600 dark:text-blue-400">{{ mesActualNombre }} {{ anioActual }}</span>.
        </p>
      </div>
    </div>

    <div v-if="cargando" class="flex justify-center py-12">
      <svg class="animate-spin h-8 w-8 text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <div v-else class="space-y-6">
      
      <!-- Tarjetas de Métricas (KPIs) -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        
        <!-- Tarjeta: Total Entregado -->
        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div class="p-3 bg-green-50 dark:bg-green-900 rounded-lg flex items-center justify-center">
            <!-- Ícono de Inventario -->
            <img src="@/assets/iconos/inventario1.png" alt="Inventario" class="w-20 h-20 object-contain" />
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wide">Insumos Entregados</p>
            <p class="text-3xl font-bold text-gray-900 dark:text-white">{{ totalArticulosEntregados }} <span class="text-sm font-normal text-gray-500">unidades</span></p>
          </div>
        </div>

        <!-- Tarjeta: Total de Vales/Salidas -->
        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div class="p-3 bg-blue-50 dark:bg-blue-900 rounded-lg flex items-center justify-center">
            <!-- Ícono de Transacciones/Flechas -->
            <img src="@/assets/iconos/flechas1.png" alt="Transacción" class="w-20 h-20 object-contain" />
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wide">Movimientos del Mes</p>
            <p class="text-3xl font-bold text-gray-900 dark:text-white">{{ totalMovimientos }} <span class="text-sm font-normal text-gray-500">registros</span></p>
          </div>
        </div>

        <!-- Tarjeta: Alertas Críticas -->
        <div class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div class="p-3 bg-red-100 dark:bg-red-900/50 rounded-lg flex items-center justify-center">
            <!-- Ícono de Warning/Stock Crítico -->
            <img src="@/assets/iconos/warning1.png" alt="Stock Crítico" class="w-20 h-20 object-contain" />
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wide">Stock Crítico</p>
            <p class="text-3xl font-bold text-gray-900 dark:text-white">{{ alertasStock.length }} <span class="text-sm font-normal text-gray-500">artículos</span></p>
          </div>
        </div>
      </div>

      <!-- Sección de Tablas de Resumen -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        <!-- Tabla: Top 5 Artículos -->
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden flex flex-col">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-900/50">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <svg class="w-5 h-5 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
              </svg>
              Top 5 Más Solicitados
            </h3>
          </div>
          <div class="p-0 flex-1">
            <ul v-if="topArticulos.length > 0" class="divide-y divide-gray-200 dark:divide-gray-700">
              <li v-for="(item, index) in topArticulos" :key="index" class="px-6 py-4 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 flex items-center justify-center font-bold text-sm">
                    {{ index + 1 }}
                  </div>
                  <div>
                    <p class="text-sm font-medium text-gray-900 dark:text-white">{{ item.articulo }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400">{{ item.tipo }}</p>
                  </div>
                </div>
                <div class="text-right">
                  <span class="text-base font-bold text-gray-900 dark:text-white">{{ item.total }}</span>
                  <span class="text-xs text-gray-500 ml-1">entregados</span>
                </div>
              </li>
            </ul>
            <div v-else class="px-6 py-8 text-center text-gray-500 dark:text-gray-400">
              No se han registrado salidas este mes.
            </div>
          </div>
        </div>

        <!-- Tabla: Alertas de Stock -->
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden flex flex-col">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-900/50">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <svg class="w-5 h-5 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
              Material por Agotarse ({{ anioActual }})
            </h3>
          </div>
          <div class="p-0 flex-1">
            <ul v-if="alertasStock.length > 0" class="divide-y divide-gray-200 dark:divide-gray-700">
              <li v-for="(item, index) in alertasStock" :key="index" class="px-6 py-4 flex items-center justify-between hover:bg-red-50/50 dark:hover:bg-red-900/10 transition-colors">
                <div>
                  <p class="text-sm font-medium text-gray-900 dark:text-white">{{ item.articulo }}</p>
                  <p class="text-xs text-gray-500 dark:text-gray-400">{{ item.tipo }} &bull; {{ item.medida }}</p>
                </div>
                <div class="text-right flex flex-col items-end">
                  <span :class="['px-2.5 py-1 rounded-full text-xs font-bold', item.stock_disponible <= 0 ? 'bg-red-100 text-red-800 dark:bg-red-900/50 dark:text-red-300' : 'bg-amber-100 text-amber-800 dark:bg-amber-900/50 dark:text-amber-300']">
                    Stock: {{ item.stock_disponible }}
                  </span>
                </div>
              </li>
            </ul>
            <div v-else class="px-6 py-8 text-center text-gray-500 dark:text-gray-400 flex flex-col items-center">
              <svg class="w-12 h-12 text-green-500 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
              <p>El inventario está en niveles óptimos.</p>
            </div>
          </div>
        </div>

      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { inventarioService } from '@/services/inventarioService'
import { useToast } from '@/composables/useToast'

const toast = useToast()
const cargando = ref(true)

// Datos crudos desde el servicio
const salidasMes = ref([])
const alertasStock = ref([])

// Configuración de Fechas para las consultas
const fechaActual = new Date()
const mesActual = fechaActual.getMonth() + 1
const anioActual = fechaActual.getFullYear()

const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
const mesActualNombre = meses[mesActual - 1]

// === CÁLCULOS COMPUTADOS PARA LOS WIDGETS ===

const totalMovimientos = computed(() => salidasMes.value.length)

const totalArticulosEntregados = computed(() => {
  return salidasMes.value.reduce((total, item) => total + Number(item.cantidad), 0)
})

const topArticulos = computed(() => {
  if (salidasMes.value.length === 0) return []

  // Agrupamos y sumamos las cantidades por artículo
  const agrupado = salidasMes.value.reduce((acc, current) => {
    if (!acc[current.articulo]) {
      acc[current.articulo] = {
        articulo: current.articulo,
        tipo: current.tipo,
        total: 0
      }
    }
    acc[current.articulo].total += Number(current.cantidad)
    return acc
  }, {})

  // Convertimos el objeto en arreglo, ordenamos de mayor a menor y cortamos a los primeros 5
  return Object.values(agrupado)
    .sort((a, b) => b.total - a.total)
    .slice(0, 5)
})

// === CARGA DE DATOS INICIAL ===
onMounted(async () => {
  try {
    const datos = await inventarioService.obtenerDatosDashboard(mesActual, anioActual)
    salidasMes.value = datos.salidas
    alertasStock.value = datos.alertas
  } catch (error) {
    console.error('Error cargando el Dashboard:', error)
    toast.error('Ocurrió un error al cargar las métricas principales.')
  } finally {
    cargando.value = false
  }
})
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s ease-in-out; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
</style>