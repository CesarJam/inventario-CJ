import { supabase } from "@/supabase";

export const noticiasService = {
  /**
   * Obtiene las noticias más recientes para mostrarlas en el Home.
   * @param {number} limite - Cantidad de noticias a mostrar (por defecto 4).
   */
  async obtenerNoticiasHome(limite = 3) {
    const { data, error } = await supabase
      .from("noticias_relevantes")
      .select("*")
      .order("prioridad", { ascending: true }) // 1ro: Ordenar por prioridad (1, 2, 3...)
      .order("created_at", { ascending: false }) // 2do: Desempate (las más nuevas primero)
      .limit(limite);

    if (error) throw error;
    return data || [];
  },

  /**
   * Obtiene absolutamente todas las noticias (Usado en el panel de Administración).
   */
  async obtenerTodas() {
    const { data, error } = await supabase
      .from("noticias_relevantes")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) throw error;
    return data || [];
  },

  /**
   * Crea una nueva noticia en la base de datos.
   * @param {Object} payload - Los datos de la noticia (titulo, descripcion, colores, etc).
   */
  async crear(payload) {
    const { data, error } = await supabase
      .from("noticias_relevantes")
      .insert([payload])
      .select();

    if (error) throw error;
    return data;
  },

  /**
   * Actualiza una noticia existente.
   * @param {string} id - El UUID de la noticia a modificar.
   * @param {Object} payload - Los nuevos datos.
   */
  async actualizar(id, payload) {
    const { data, error } = await supabase
      .from("noticias_relevantes")
      .update(payload)
      .eq("id", id)
      .select();

    if (error) throw error;
    return data;
  },

  /**
   * Elimina una noticia de la base de datos.
   * @param {string} id - El UUID de la noticia a borrar.
   */
  async eliminar(id) {
    const { error } = await supabase
      .from("noticias_relevantes")
      .delete()
      .eq("id", id);

    if (error) throw error;
    return true;
  },
};
