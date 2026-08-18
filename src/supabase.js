// src/supabase.js
import { createClient } from '@supabase/supabase-js'

// 1. Obtenemos la IP desde la que el usuario está viendo la página web
const hostname = window.location.hostname

// 2. Si la IP empieza con "100." (rango de Tailscale), usamos esa URL.
const isTailscale = hostname.startsWith('100.')

const supabaseUrl = isTailscale 
  ? import.meta.env.VITE_SUPABASE_URL_TAILSCALE 
  : import.meta.env.VITE_SUPABASE_URL

const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

// 3. Validación simple para desarrollo
if (!supabaseUrl || !supabaseAnonKey) {
  console.error("Faltan las variables de entorno de Supabase. Verifica tu archivo .env")
}

// 4. Inicializamos el cliente con la URL correcta
export const supabase = createClient(supabaseUrl, supabaseAnonKey)