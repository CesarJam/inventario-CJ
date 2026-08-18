<template>
  <div class="space-y-6 animate-fade-in">
    
    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
      <div>
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Reportes de Inventario</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Consulta los movimientos históricos de material.
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
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
            </svg>
            CSV
          </button>
          <button 
            @click="exportarPDF"
            :disabled="datosMostrar.length === 0"
            class="flex items-center gap-1.5 px-3 py-1.5 bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 dark:bg-red-900/30 dark:text-red-400 dark:border-red-800 rounded-lg text-sm font-medium transition-colors disabled:opacity-50"
            title="Descargar PDF"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path>
            </svg>
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

      <!-- Nuevo Filtro: Categoría -->
      <div>
        <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Categoría</label>
        <select v-model="filtros.tipo" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-white sm:text-sm">
          <option value="Todos">Todas</option>
          <option value="Oficina">Oficina</option>
          <option value="Limpieza">Limpieza</option>
        </select>
      </div>

      <!-- Filtro Área (Ocupa 2 columnas para equilibrar la cuadrícula) -->
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
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
            
            <tr v-if="cargando">
              <td :colspan="pestanaActiva === 'salidas' ? 5 : 5" class="px-6 py-12 text-center text-sm text-gray-500">Cargando reporte...</td>
            </tr>

            <tr v-else-if="datosMostrar.length === 0">
              <td :colspan="pestanaActiva === 'salidas' ? 5 : 5" class="px-6 py-12 text-center text-sm text-gray-500">No hay registros para este periodo.</td>
            </tr>

            <tr v-else v-for="item in datosMostrar" :key="item.id" class="hover:bg-gray-50 dark:hover:bg-gray-700/50">
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
            </tr>

          </tbody>
        </table>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
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
  tipo: 'Todos', // Nuevo estado para categoría
  area_id: 'todas'
})

// Filtrado de datos en el cliente
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

onMounted(async () => {
  try {
    areas.value = await inventarioService.obtenerAreas()
    await cargarReportes()
  } catch (error) {
    toast.error('Error de inicialización')
  }
})

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

  // Agregar BOM (\uFEFF) para que Excel lea correctamente los acentos (UTF-8)
  let csvContent = "\uFEFF" + encabezados.join(";") + "\n"
  
  filas.forEach(fila => {
    // Escapamos las comillas y envolvemos cada campo para evitar que las comas en las observaciones rompan el CSV
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

  // Configuración de Cabecera del Documento
  doc.setFontSize(16)
  doc.setTextColor(31, 41, 55) // text-gray-800
  doc.text(titulo, 14, 15)
  
  doc.setFontSize(10)
  doc.setTextColor(107, 114, 128) // text-gray-500
  doc.text(`Generado el: ${formatearFecha(new Date())}`, 14, 22)
  doc.text(`Categoría: ${filtros.value.tipo}`, 14, 27)

  let columnas = []
  let filas = []

  // Preparación de datos para la tabla
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

  // Generar la tabla con autoTable pasándole el 'doc' como primer parámetro
  autoTable(doc, {
    head: columnas,
    body: filas,
    startY: 32, // Bajamos el inicio para no sobreescribir la categoría
    styles: { 
      fontSize: 8,
      cellPadding: 3,
    },
    headStyles: { 
      fillColor: [37, 99, 235], // Azul acorde al diseño (blue-600)
      textColor: [255, 255, 255],
      fontStyle: 'bold'
    },
    alternateRowStyles: {
      fillColor: [249, 250, 251] // gray-50
    },
    margin: { top: 32 }
  })
  
  // Descargar el archivo
  doc.save(`${nombreArchivoBase.value}.pdf`)
}
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s ease-in-out; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
</style>