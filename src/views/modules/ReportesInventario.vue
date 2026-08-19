<template>
  <div class="space-y-6 animate-fade-in">
    
    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
      <div>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Reportes de Inventario</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Consulta y gestiona los movimientos históricos de material.
        </p>
      </div>
      
      <!-- Controles Superiores: Pestañas y Exportación -->
      <div class="flex flex-wrap items-center gap-3 w-full md:w-auto">
        <!-- Selector de Pestañas -->
        <div class="flex p-1 bg-gray-100 dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700">
          <button 
            @click="pestanaActiva = 'salidas'"
            :class="['px-4 py-1.5 text-sm font-medium rounded-md transition-colors', pestanaActiva === 'salidas' ? 'bg-white dark:bg-gray-700 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-gray-500 hover:text-gray-700 dark:text-gray-400']"
          >
            Salidas de Material
          </button>
          <button 
            @click="pestanaActiva = 'entradas'"
            :class="['px-4 py-1.5 text-sm font-medium rounded-md transition-colors', pestanaActiva === 'entradas' ? 'bg-white dark:bg-gray-700 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-gray-500 hover:text-gray-700 dark:text-gray-400']"
          >
            Entradas al Almacén
          </button>
        </div>

        <!-- Botones de Exportación -->
        <div class="flex gap-2 ml-auto md:ml-0">
          <button 
            @click="exportarCSV"
            :disabled="datosMostrar.length === 0"
            class="flex items-center gap-1.5 px-3 py-1.5 bg-green-50 text-green-700 border border-green-200 hover:bg-green-100 dark:bg-green-900/30 dark:text-green-400 dark:border-green-800 rounded-lg text-sm font-medium transition-colors disabled:opacity-50"
            title="Exportar a Excel (CSV)"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
            CSV
          </button>
          <button 
            @click="exportarPDF"
            :disabled="datosMostrar.length === 0"
            class="flex items-center gap-1.5 px-3 py-1.5 bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 dark:bg-red-900/30 dark:text-red-400 dark:border-red-800 rounded-lg text-sm font-medium transition-colors disabled:opacity-50"
            title="Descargar PDF"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
            PDF
          </button>
        </div>
      </div>
    </div>

    <!-- Barra de Filtros -->
    <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm grid grid-cols-1 md:grid-cols-5 gap-4">
      <div>
        <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Año</label>
        <select v-model="filtros.anio" @change="cargarReportes" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white sm:text-sm">
          <option v-for="year in anosDisponibles" :key="year" :value="year">{{ year }}</option>
        </select>
      </div>

      <div>
        <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Mes</label>
        <select v-model="filtros.mes" @change="cargarReportes" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white sm:text-sm">
          <option v-for="(mes, index) in meses" :key="index" :value="index + 1">{{ mes }}</option>
        </select>
      </div>

      <div>
        <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Categoría</label>
        <select v-model="filtros.tipo" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white sm:text-sm">
          <option value="Todos">Todas</option>
          <option value="Oficina">Oficina</option>
          <option value="Limpieza">Limpieza</option>
        </select>
      </div>

      <div class="md:col-span-2" v-if="pestanaActiva === 'salidas'">
        <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Área Solicitante</label>
        <select v-model="filtros.area_id" @change="cargarReportes" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white sm:text-sm">
          <option value="todas">Todas las Áreas</option>
          <option v-for="area in areas" :key="area.id" :value="area.id">{{ area.seccion }}</option>
        </select>
      </div>
    </div>

    <!-- Tabla de Reportes -->
    <div class="bg-white dark:bg-gray-800 shadow-sm rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-900/50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Fecha</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Artículo</th>
              <th class="px-6 py-3 text-center text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Cant.</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Movimiento</th>
              <th v-if="pestanaActiva === 'salidas'" class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Área / Folio</th>
              <th v-if="pestanaActiva === 'entradas'" class="px-6 py-3 text-left text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Observaciones</th>
              <th class="px-6 py-3 text-right text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
            
            <tr v-if="cargando">
              <td :colspan="pestanaActiva === 'salidas' ? 7 : 6" class="px-6 py-12 text-center text-sm text-gray-500">Cargando reporte...</td>
            </tr>

            <tr v-else-if="datosMostrar.length === 0">
              <td :colspan="pestanaActiva === 'salidas' ? 7 : 6" class="px-6 py-12 text-center text-sm text-gray-500">No hay registros para este periodo.</td>
            </tr>

            <tr v-else v-for="item in datosMostrar" :key="item.id" class="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">
                {{ formatearFecha(pestanaActiva === 'salidas' ? item.fecha_aprobacion : item.fecha_entrada) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900 dark:text-white">{{ item.articulo }}</div>
                <div class="text-xs text-gray-500 dark:text-gray-400">
                  {{ item.medida }} &bull; <span :class="item.tipo === 'Oficina' ? 'text-blue-500' : 'text-green-500'">{{ item.tipo }}</span>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-center text-gray-900 dark:text-white">
                {{ item.cantidad }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 dark:text-gray-300">
                {{ pestanaActiva === 'salidas' ? item.tipo_salida : item.tipo_entrada }}
              </td>
              <td v-if="pestanaActiva === 'salidas'" class="px-6 py-4">
                <div class="text-sm text-gray-900 dark:text-white truncate max-w-xs" :title="item.area_nombre">{{ item.area_nombre }}</div>
                <div v-if="item.folio_vale" class="text-xs text-blue-600 font-semibold">{{ item.folio_vale }}</div>
              </td>
              <td v-if="pestanaActiva === 'entradas'" class="px-6 py-4 text-sm text-gray-700 dark:text-gray-300 truncate max-w-xs">
                {{ item.observacion || '-' }}
              </td>
              <!-- NUEVA COLUMNA DE ACCIONES -->
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <button @click="abrirEditar(item)" class="text-blue-600 hover:text-blue-900 dark:text-blue-400 dark:hover:text-blue-300 mr-3">Editar</button>
                <button @click="eliminarRegistro(item.id)" class="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300">Eliminar</button>
              </td>
            </tr>

          </tbody>
        </table>
      </div>
    </div>

<!-- MODAL DE EDICIÓN PARA SALIDAS -->
    <transition name="modal-fade">
      <div v-if="mostrarModalSalida" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-5xl overflow-hidden border border-gray-200 dark:border-gray-700 flex flex-col max-h-[90vh]">
          
          <!-- Encabezado -->
          <div class="px-6 py-5 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center bg-gray-50 dark:bg-gray-900/50 shrink-0">
            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Editar Salida de Material</h3>
            <button @click="mostrarModalSalida = false" class="text-gray-400 hover:text-gray-500 focus:outline-none transition-colors">
              <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
          </div>

          <!-- Cuerpo del Formulario con Grid de 3 Columnas -->
          <form @submit.prevent="guardarEdicion" class="p-6 md:p-8 overflow-y-auto flex-1 flex flex-col">
            
            <div class="grid grid-cols-1 md:grid-cols-[1fr_1.5fr_1fr] gap-8 flex-1">
              
              <!-- COLUMNA 1: Artículo e Imagen -->
              <div class="space-y-4 flex flex-col">
                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Artículo</label>
                  <input type="text" :value="formularioEdicion.articulo_nombre" disabled class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 cursor-not-allowed">
                </div>

                <!-- Contenedor de la Imagen Dinámica -->
                <div class="w-full aspect-square bg-gray-100 dark:bg-gray-900/50 rounded-xl border border-gray-200 dark:border-gray-700 flex items-center justify-center overflow-hidden shadow-inner">
                  <img v-if="formularioEdicion.imagen_url" :src="formularioEdicion.imagen_url" class="w-full h-full object-cover transition-opacity duration-300" />
                  <div v-else class="flex flex-col items-center justify-center text-gray-400">
                    <svg class="h-16 w-16 mb-2 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    <span class="text-sm font-medium">Sin imagen</span>
                  </div>
                </div>
              </div>

              <!-- COLUMNA 2: Detalles (Área, Cantidad, Tipo, Folio, Fecha) -->
              <div class="space-y-5 flex flex-col">
                
                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Área Solicitante</label>
                  <select v-model="formularioEdicion.area_id" required class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                    <option v-for="area in areas" :key="area.id" :value="area.id">{{ area.seccion }}</option>
                  </select>
                </div>

                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Cantidad</label>
                    <input type="number" v-model="formularioEdicion.cantidad" required min="1" class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                  </div>
                  <div>
                    <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Tipo de Salida</label>
                    <select v-model="formularioEdicion.tipo_salida" required class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                      <option value="Mensual">Dotación Mensual</option>
                      <option value="Vale">Vale Esporádico</option>
                    </select>
                  </div>
                </div>

                <div v-if="formularioEdicion.tipo_salida === 'Vale'" class="animate-fade-in">
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Folio del Vale</label>
                  <input type="text" v-model="formularioEdicion.folio_vale" required class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                </div>

                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Fecha de Entrega</label>
                  <input type="datetime-local" v-model="formularioEdicion.fecha_aprobacion" required class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                </div>
              </div>

              <!-- COLUMNA 3: Observaciones -->
              <div class="flex flex-col h-full">
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Observaciones</label>
                <textarea v-model="formularioEdicion.observacion" placeholder="Detalles de la entrega..." class="w-full flex-1 px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 resize-none"></textarea>
                <p class="text-sm text-gray-500 mt-2">Modifica las notas o referencias de esta salida de material.</p>
              </div>

            </div>

            <!-- Botones de Acción (Base) -->
            <div class="pt-6 mt-8 border-t border-gray-200 dark:border-gray-700 flex gap-4 justify-end shrink-0">
              <button type="button" @click="mostrarModalSalida = false" class="px-6 py-3 text-lg font-medium bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">Cancelar</button>
              <button type="submit" :disabled="guardandoEdicion" class="px-6 py-3 text-lg font-medium bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 disabled:opacity-50">Guardar Cambios</button>
            </div>

          </form>
        </div>
      </div>
    </transition>

<!-- MODAL DE EDICIÓN PARA ENTRADAS -->
    <transition name="modal-fade">
      <div v-if="mostrarModalEntrada" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-5xl overflow-hidden border border-gray-200 dark:border-gray-700 flex flex-col max-h-[90vh]">
          
          <!-- Encabezado -->
          <div class="px-6 py-5 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center bg-gray-50 dark:bg-gray-900/50 shrink-0">
            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Editar Entrada de Material</h3>
            <button @click="mostrarModalEntrada = false" class="text-gray-400 hover:text-gray-500 focus:outline-none transition-colors">
              <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
          </div>

          <!-- Cuerpo del Formulario con Grid de 3 Columnas -->
          <form @submit.prevent="guardarEdicion" class="p-6 md:p-8 overflow-y-auto flex-1 flex flex-col">
            
            <div class="grid grid-cols-1 md:grid-cols-[1fr_1.5fr_1fr] gap-8 flex-1">
              
              <!-- COLUMNA 1: Artículo e Imagen -->
              <div class="space-y-4 flex flex-col">
                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Artículo</label>
                  <input type="text" :value="formularioEdicion.articulo_nombre" disabled class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 cursor-not-allowed">
                </div>

                <!-- Contenedor de la Imagen Dinámica -->
                <div class="w-full aspect-square bg-gray-100 dark:bg-gray-900/50 rounded-xl border border-gray-200 dark:border-gray-700 flex items-center justify-center overflow-hidden shadow-inner">
                  <img v-if="formularioEdicion.imagen_url" :src="formularioEdicion.imagen_url" class="w-full h-full object-cover transition-opacity duration-300" />
                  <div v-else class="flex flex-col items-center justify-center text-gray-400">
                    <svg class="h-16 w-16 mb-2 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    <span class="text-sm font-medium">Sin imagen</span>
                  </div>
                </div>
              </div>

              <!-- COLUMNA 2: Detalles (Cantidad, Tipo, Fecha) -->
              <div class="space-y-5 flex flex-col">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Cantidad</label>
                    <input type="number" v-model="formularioEdicion.cantidad" required min="1" class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                  </div>
                  <div>
                    <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Tipo de Entrada</label>
                    <select v-model="formularioEdicion.tipo_entrada" required class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                      <option value="Stock Inicial">Stock Inicial (Anual)</option>
                      <option value="Ingreso Esporádico">Ingreso Esporádico</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Fecha de Ingreso</label>
                  <input type="datetime-local" v-model="formularioEdicion.fecha_entrada" required class="w-full px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500">
                </div>
              </div>

              <!-- COLUMNA 3: Observaciones -->
              <div class="flex flex-col h-full">
                <label class="block text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">Observaciones</label>
                <textarea v-model="formularioEdicion.observacion" placeholder="Notas de la entrada..." class="w-full flex-1 px-4 py-3 text-lg border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white focus:ring-blue-500 resize-none"></textarea>
                <p class="text-sm text-gray-500 mt-2">Modifica las notas o referencias de este ingreso.</p>
              </div>

            </div>

            <!-- Botones de Acción (Base) -->
            <div class="pt-6 mt-8 border-t border-gray-200 dark:border-gray-700 flex gap-4 justify-end shrink-0">
              <button type="button" @click="mostrarModalEntrada = false" class="px-6 py-3 text-lg font-medium bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-200 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">Cancelar</button>
              <button type="submit" :disabled="guardandoEdicion" class="px-6 py-3 text-lg font-medium bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2 disabled:opacity-50">Guardar Cambios</button>
            </div>

          </form>
        </div>
      </div>
    </transition>

  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { inventarioService } from '@/services/inventarioService'
import { useToast } from '@/composables/useToast'
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

const toast = useToast()
const cargando = ref(false)
const pestanaActiva = ref('salidas') 
const areas = ref([])
const salidas = ref([])
const entradas = ref([])

const hoy = new Date()
const anosDisponibles = [hoy.getFullYear() - 1, hoy.getFullYear(), hoy.getFullYear() + 1]
const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']

const filtros = ref({
  mes: hoy.getMonth() + 1,
  anio: hoy.getFullYear(),
  tipo: 'Todos',
  area_id: 'todas'
})

// Estados para Edición
const mostrarModalSalida = ref(false)
const mostrarModalEntrada = ref(false)
const guardandoEdicion = ref(false)
const formularioEdicion = ref({})

const datosMostrar = computed(() => {
  let baseDatos = pestanaActiva.value === 'salidas' ? salidas.value : entradas.value;
  if (filtros.value.tipo !== 'Todos') {
    baseDatos = baseDatos.filter(item => item.tipo === filtros.value.tipo);
  }
  return baseDatos;
})

const formatearFecha = (fechaISO) => {
  if (!fechaISO) return '';
  const fecha = new Date(fechaISO);
  return fecha.toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
}

// Convertir de ISO de base de datos al formato requerido por input type="datetime-local" (YYYY-MM-DDTHH:mm)
const formatearFechaInput = (fechaISO) => {
  if (!fechaISO) return '';
  const fecha = new Date(fechaISO);
  fecha.setMinutes(fecha.getMinutes() - fecha.getTimezoneOffset());
  return fecha.toISOString().slice(0, 16);
}

const cargarReportes = async () => {
  cargando.value = true
  try {
    if (pestanaActiva.value === 'salidas') {
      salidas.value = await inventarioService.obtenerReporteSalidas(filtros.value.mes, filtros.value.anio, filtros.value.area_id)
    } else {
      entradas.value = await inventarioService.obtenerReporteEntradas(filtros.value.mes, filtros.value.anio)
    }
  } catch (error) {
    console.error(error)
    toast.error('Error al cargar los reportes')
  } finally {
    cargando.value = false
  }
}

watch(pestanaActiva, () => {
  cargarReportes()
})

const manejarTeclado = (e) => {
  if (e.key === 'Escape') {
    mostrarModalEntrada.value = false
    mostrarModalSalida.value = false
  }
}

onUnmounted(() => {
  window.removeEventListener('keydown', manejarTeclado)
})

onMounted(async () => {
  window.addEventListener('keydown', manejarTeclado)
  try {
    areas.value = await inventarioService.obtenerAreas()
    await cargarReportes()
  } catch (error) {
    toast.error('Error de inicialización')
  }
})

// ==========================================
// LÓGICA DE EDICIÓN Y ELIMINACIÓN
// ==========================================
const abrirEditar = (item) => {
  formularioEdicion.value = { 
    ...item, 
    articulo_nombre: `${item.articulo} (${item.medida})`, // Solo para visualizar en el input deshabilitado
    imagen_url: item.imagen_url || null
  }
  
  if (pestanaActiva.value === 'salidas') {
    formularioEdicion.value.fecha_aprobacion = formatearFechaInput(item.fecha_aprobacion)
    mostrarModalSalida.value = true
  } else {
    formularioEdicion.value.fecha_entrada = formatearFechaInput(item.fecha_entrada)
    mostrarModalEntrada.value = true
  }
}

const guardarEdicion = async () => {
  guardandoEdicion.value = true
  try {
    const { id, cantidad, observacion } = formularioEdicion.value
    
    if (pestanaActiva.value === 'salidas') {
      const { area_id, tipo_salida, folio_vale, fecha_aprobacion } = formularioEdicion.value
      await inventarioService.actualizarSalida(id, { 
        cantidad, area_id, tipo_salida, folio_vale, fecha_aprobacion, observacion 
      })
      toast.success('Salida actualizada correctamente')
      mostrarModalSalida.value = false
    } else {
      const { tipo_entrada, fecha_entrada } = formularioEdicion.value
      await inventarioService.actualizarEntrada(id, { 
        cantidad, tipo_entrada, fecha_entrada, observacion 
      })
      toast.success('Entrada actualizada correctamente')
      mostrarModalEntrada.value = false
    }
    await cargarReportes()
  } catch (error) {
    console.error(error)
    toast.error('Error al actualizar el registro')
  } finally {
    guardandoEdicion.value = false
  }
}

const eliminarRegistro = async (id) => {
  const confirmacion = confirm("¿Estás seguro de que deseas eliminar este registro? Esto afectará los totales anuales del stock.");
  if (!confirmacion) return;

  try {
    if (pestanaActiva.value === 'salidas') {
      await inventarioService.eliminarSalida(id);
      toast.success('Registro de salida eliminado');
    } else {
      await inventarioService.eliminarEntrada(id);
      toast.success('Registro de entrada eliminado');
    }
    await cargarReportes();
  } catch (error) {
    console.error(error);
    toast.error('Ocurrió un error al eliminar el registro');
  }
}

// ==========================================
// LÓGICA DE EXPORTACIÓN (CSV Y PDF)
// ==========================================
const nombreArchivoBase = computed(() => {
  const mesNombre = meses[filtros.value.mes - 1]
  const catNombre = filtros.value.tipo !== 'Todos' ? `_${filtros.value.tipo}` : ''
  return `Reporte_${pestanaActiva.value}${catNombre}_${mesNombre}_${filtros.value.anio}`
})

const exportarCSV = () => {
  if (datosMostrar.value.length === 0) return toast.info('No hay datos para exportar')

  let encabezados = []
  let filas = []

  if (pestanaActiva.value === 'salidas') {
    encabezados = ['Fecha', 'Articulo', 'Medida', 'Categoria', 'Cantidad', 'Tipo Salida', 'Area', 'Folio', 'Observaciones']
    filas = datosMostrar.value.map(i => [
      formatearFecha(i.fecha_aprobacion),
      i.articulo, i.medida, i.tipo, i.cantidad, i.tipo_salida, 
      i.area_nombre || '', i.folio_vale || '', i.observacion || ''
    ])
  } else {
    encabezados = ['Fecha', 'Articulo', 'Medida', 'Categoria', 'Cantidad', 'Tipo Entrada', 'Observaciones']
    filas = datosMostrar.value.map(i => [
      formatearFecha(i.fecha_entrada),
      i.articulo, i.medida, i.tipo, i.cantidad, i.tipo_entrada, i.observacion || ''
    ])
  }

  let csvContent = "\uFEFF" + encabezados.join(";") + "\n"
  filas.forEach(fila => {
    let filaFormateada = fila.map(campo => `"${String(campo).replace(/"/g, '""')}"`).join(";")
    csvContent += filaFormateada + "\n"
  })

  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement("a")
  const url = URL.createObjectURL(blob)
  
  link.setAttribute("href", url)
  link.setAttribute("download", `${nombreArchivoBase.value}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)
}

const exportarPDF = () => {
  if (datosMostrar.value.length === 0) return toast.info('No hay datos para exportar')

  const doc = new jsPDF()
  const mesNombre = meses[filtros.value.mes - 1]
  const titulo = `Reporte de ${pestanaActiva.value.toUpperCase()} - ${mesNombre} ${filtros.value.anio}`

  doc.setFontSize(16)
  doc.setTextColor(31, 41, 55)
  doc.text(titulo, 14, 15)
  
  doc.setFontSize(10)
  doc.setTextColor(107, 114, 128)
  doc.text(`Generado el: ${formatearFecha(new Date())}`, 14, 22)
  doc.text(`Categoría: ${filtros.value.tipo}`, 14, 27)

  let columnas = []
  let filas = []

  if (pestanaActiva.value === 'salidas') {
    columnas = [['Fecha', 'Artículo', 'Cant.', 'Movimiento', 'Área Destino', 'Observaciones']]
    filas = datosMostrar.value.map(i => [
      formatearFecha(i.fecha_aprobacion),
      `${i.articulo} (${i.medida}) [${i.tipo}]`,
      i.cantidad,
      i.tipo_salida + (i.folio_vale ? `\nFolio: ${i.folio_vale}` : ''),
      i.area_nombre || '-',
      i.observacion || '-'
    ])
  } else {
    columnas = [['Fecha', 'Artículo', 'Cant.', 'Tipo de Ingreso', 'Observaciones']]
    filas = datosMostrar.value.map(i => [
      formatearFecha(i.fecha_entrada),
      `${i.articulo} (${i.medida}) [${i.tipo}]`,
      i.cantidad,
      i.tipo_entrada,
      i.observacion || '-'
    ])
  }

  autoTable(doc, {
    head: columnas,
    body: filas,
    startY: 32,
    styles: { fontSize: 8, cellPadding: 3 },
    headStyles: { fillColor: [37, 99, 235], textColor: [255, 255, 255], fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [249, 250, 251] },
    margin: { top: 32 }
  })
  
  doc.save(`${nombreArchivoBase.value}.pdf`)
}
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s ease-in-out; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity 0.3s ease; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
</style>