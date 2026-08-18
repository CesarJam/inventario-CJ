import { supabase } from '../supabase.js'

export const authService = {
  /**
   * Inicia sesión con Correo y Contraseña administrados por tu Supabase local.
   */
  async loginWithEmail(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password
    })
    
    if (error) throw error
    return data
  },

  /**
   * Cierra la sesión activa en el cliente y en el servidor.
   */
  async logout() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
  },

  /**
   * Recupera la sesión actual almacenada localmente (localStorage).
   */
  async getSession() {
    const { data, error } = await supabase.auth.getSession()
    if (error) throw error
    return data.session
  },

  /**
   * Verifica la Lista Blanca (Whitelist).
   * Cruza el email autenticado con la tabla 'usuarios' para obtener el rol.
   * @param {string} email - El correo del usuario autenticado.
   * @returns {Object|null} - Retorna los datos del usuario (id, rol, nombre) o null si no tiene acceso.
   */
  async checkWhitelist(email) {
    if (!email) return null

    const { data, error } = await supabase
      .from('usuarios')
      .select('*')
      .eq('email', email)
      .single()

    if (error) {
      console.warn('Acceso denegado: Usuario no encontrado en la lista blanca.')
      return null
    }

    return data
  },

  /**
   * Registra un nuevo usuario en Supabase Auth.
   * @param {string} email - Correo del usuario
   * @param {string} password - Contraseña del usuario
   * @param {string} displayName - Nombre completo para guardar en los metadatos
   */
  async registerUser(email, password, displayName) {
    const { data, error } = await supabase.auth.signUp({
      email: email,
      password: password,
      options: {
        data: {
          display_name: displayName
        }
      }
    })
    
    if (error) throw error
    return data
  },

  /**
   * Envía un correo electrónico con el enlace para restablecer la contraseña.
   * @param {string} email - Correo del usuario
   * @param {string} redirectToUrl - URL a la que se redirigirá tras hacer clic en el enlace
   */
  async resetPassword(email, redirectToUrl) {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: redirectToUrl,
    })
    
    if (error) throw error
    return data
  },

  /**
   * Actualiza la contraseña del usuario actualmente autenticado (o que acaba de recuperar su cuenta vía token).
   * @param {string} newPassword - La nueva contraseña del usuario
   */
  async updatePassword(newPassword) {
    const { data, error } = await supabase.auth.updateUser({
      password: newPassword
    })
    
    if (error) throw error
    return data
  } 
}