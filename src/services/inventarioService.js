import { supabase } from '@/supabase'

export const inventarioService = {
  /**
   * Obtiene el catálogo completo y el stock calculado en tiempo real
   * desde la vista de inventario.
   */
  async obtenerInventarioActual() {
    const { data, error } = await supabase
      .schema('inventario')
      .from('vista_inventario_actual')
      .select('*')
      .order('articulo', { ascending: true })

    if (error) {
      throw error // Lanzamos el error para que el componente lo maneje
    }
    
    return data || []
  },

  /**
   * Obtiene solo el catálogo de artículos para los selectores
   */
  async obtenerArticulos() {
    const { data, error } = await supabase
      .schema('inventario')
      .from('articulos')
      .select('id, articulo, medida')
      .order('articulo', { ascending: true })

    if (error) throw error
    return data || []
  },

  /**
   * Registra una nueva entrada de material
   */
  async registrarEntrada(datosEntrada) {
    const { error } = await supabase
      .schema('inventario')
      .from('entradas_material')
      .insert([datosEntrada])

    if (error) throw error
    return true
  },

  /**
   * Obtiene las áreas de la tabla cuadro_general (esquema public)
   */
  async obtenerAreas() {
    const { data, error } = await supabase
      .schema('public') // Apuntamos al esquema por defecto
      .from('cuadro_general')
      .select('id, seccion')
      .order('seccion', { ascending: true })

    if (error) throw error
    return data || []
  },

  /**
   * Registra una nueva salida de material
   */
  async registrarSalida(datosSalida) {
    const { error } = await supabase
      .schema('inventario')
      .from('salidas_material')
      .insert([{
        ...datosSalida,
        // Forzamos el estado a 'aprobado' para que la vista lo reste automáticamente del stock
        estado: 'aprobado' 
      }])

    if (error) throw error
    return true
  },

  //Consulta de vistas
  /**
   * Obtiene el reporte de entradas filtrado por mes y año
   */
  async obtenerReporteEntradas(mes, anio) {
    const { data, error } = await supabase
      .schema('inventario')
      .from('vista_reporte_entradas')
      .select('*')
      .eq('mes', mes)
      .eq('anio', anio)
      .order('fecha_entrada', { ascending: false });

    if (error) throw error;
    return data || [];
  },

  /**
   * Obtiene el reporte de salidas filtrado por mes, año y opcionalmente área
   */
  async obtenerReporteSalidas(mes, anio, areaId = 'todas') {
    let query = supabase
      .schema('inventario')
      .from('vista_reporte_salidas')
      .select('*')
      .eq('mes', mes)
      .eq('anio', anio);

    // Si se especifica un área, agregamos el filtro
    if (areaId !== 'todas') {
      query = query.eq('area_id', areaId);
    }

    const { data, error } = await query.order('fecha_aprobacion', { ascending: false });

    if (error) throw error;
    return data || [];
  },


  // ==========================================
  // CRUD DE CATÁLOGO DE ARTÍCULOS
  // ==========================================

  async obtenerCatalogoCompleto() {
    const { data, error } = await supabase
      .schema('inventario')
      .from('articulos')
      .select('*')
      .order('articulo', { ascending: true });

    if (error) throw error;
    return data || [];
  },

  async guardarArticulo(articulo) {
    const { error } = await supabase
      .schema('inventario')
      .from('articulos')
      .insert([articulo]);

    if (error) throw error;
    return true;
  },

  async actualizarArticulo(id, articulo) {
    const { error } = await supabase
      .schema('inventario')
      .from('articulos')
      .update(articulo)
      .eq('id', id);

    if (error) throw error;
    return true;
  },

  async eliminarArticulo(id) {
    const { error } = await supabase
      .schema('inventario')
      .from('articulos')
      .delete()
      .eq('id', id);

    if (error) throw error;
    return true;
  },

  // ==========================================
  // STORAGE: SUBIDA DE IMÁGENES
  // ==========================================
  
  async subirImagen(archivoFile) {
    // Generar un nombre único para evitar que se sobrescriban
    const extension = archivoFile.name.split('.').pop();
    const nombreArchivo = `${Date.now()}_${Math.random().toString(36).substring(2)}.${extension}`;
    
    // Subir al bucket 'articulos'
    const { data, error } = await supabase.storage
      .from('articulos')
      .upload(`public/${nombreArchivo}`, archivoFile, {
        cacheControl: '3600',
        upsert: false
      });

    if (error) throw error;

    // Obtener la URL pública para guardarla en la base de datos
    const { data: publicUrlData } = supabase.storage
      .from('articulos')
      .getPublicUrl(`public/${nombreArchivo}`);

    return publicUrlData.publicUrl;
  },

  /**
   * Obtiene el inventario cruzado por el año seleccionado
   */
  async obtenerInventarioPorAnio(anio) {
    const { data, error } = await supabase
      .schema('inventario')
      .from('vista_inventario_anual')
      .select('*')
      .eq('anio', anio)
      .order('articulo', { ascending: true })

    if (error) throw error
    return data || []
  },


  // ==========================================
  // WIDGETS DEL DASHBOARD PRINCIPAL
  // ==========================================

  async obtenerDatosDashboard(mes, anio) {
    // 1. Obtener todas las salidas del mes actual para calcular totales y el Top 5
    const { data: salidas, error: errorSalidas } = await supabase
      .schema('inventario')
      .from('vista_reporte_salidas')
      .select('articulo, cantidad, tipo')
      .eq('mes', mes)
      .eq('anio', anio);

    if (errorSalidas) throw errorSalidas;

    // 2. Obtener los artículos con stock crítico (5 o menos) del año en curso
    const { data: alertas, error: errorAlertas } = await supabase
      .schema('inventario')
      .from('vista_inventario_anual')
      .select('articulo, medida, tipo, stock_disponible')
      .eq('anio', anio)
      .lte('stock_disponible', 5) // Menor o igual a 5
      .order('stock_disponible', { ascending: true })
      .limit(10); // Solo mostramos los 10 más urgentes

    if (errorAlertas) throw errorAlertas;

    return { 
      salidas: salidas || [], 
      alertas: alertas || [] 
    };
  },

  // --- ACTUALIZAR Y ELIMINAR ENTRADAS ---
  async actualizarEntrada(id, datos) {
    const { error } = await supabase
      .schema('inventario') // <-- Apuntamos al esquema correcto
      .from('entradas_material')
      .update(datos)
      .eq('id', id)
    if (error) throw error
  },

  async eliminarEntrada(id) {
    const { error } = await supabase
      .schema('inventario')
      .from('entradas_material')
      .delete()
      .eq('id', id)
    if (error) throw error
  },

  // --- ACTUALIZAR Y ELIMINAR SALIDAS ---
  async actualizarSalida(id, datos) {
    const { error } = await supabase
      .schema('inventario')
      .from('salidas_material')
      .update(datos)
      .eq('id', id)
    if (error) throw error
  },

  async eliminarSalida(id) {
    const { error } = await supabase
      .schema('inventario')
      .from('salidas_material')
      .delete()
      .eq('id', id)
    if (error) throw error
  }



}