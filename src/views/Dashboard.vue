<template>
  <div class="flex h-screen overflow-hidden bg-gray-100 dark:bg-gray-900 transition-colors duration-300">

    <div v-if="isMobileMenuOpen" @click="isMobileMenuOpen = false"
      class="fixed inset-0 bg-black/50 z-20 md:hidden transition-opacity"></div>

    <aside :class="[
      'fixed inset-y-0 left-0 z-30 w-64 bg-white dark:bg-gray-800 shadow-xl border-r border-gray-200 dark:border-gray-700 transform transition-transform duration-300 ease-in-out flex flex-col md:relative md:translate-x-0',
      isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
    ]">

      <div class="p-6 text-center border-b border-gray-200 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-900/20">

        <div class="relative w-20 h-20 mx-auto group cursor-pointer" @click="triggerFileInput">
          <img :src="userProfile.avatar" alt="Avatar"
            class="w-full h-full rounded-full shadow-md border-2 border-blue-500 p-0.5 object-cover transition-opacity"
            :class="{ 'opacity-50': uploadingAvatar }" />

          <div
            class="absolute inset-0 bg-black/40 rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
            <svg v-if="!uploadingAvatar" class="w-6 h-6 text-white" fill="none" stroke="currentColor"
              viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z">
              </path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>

            <svg v-else class="animate-spin h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
              </path>
            </svg>
          </div>

          <input type="file" ref="fileInput" accept="image/png, image/jpeg, image/jpg" class="hidden"
            @change="subirAvatar" />
        </div>

        <h2 class="mt-3 font-semibold text-gray-800 dark:text-white truncate px-2">
          Hola, {{ userProfile.name }}
        </h2>
        <span class="text-xs text-blue-600 dark:text-blue-400 font-medium uppercase tracking-wider">
          {{ userRole }}
        </span>
      </div>

      <nav class="flex-1 overflow-y-auto py-4 space-y-1 px-3">
        <router-link :to="{ name: 'Home' }"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          exact-active-class="bg-blue-50 dark:bg-blue-900/50 text-blue-600 dark:text-blue-400 font-semibold">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6">
            </path>
          </svg>
          Inicio
        </router-link>




        <router-link :to="{ name: 'Inventario' }"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          active-class="bg-blue-50 dark:bg-blue-900/50 text-blue-600 dark:text-blue-400 font-semibold">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10">
            </path>
          </svg>
          Inventario Material
        </router-link>

        <router-link to="/reportes-inventario"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          active-class="bg-blue-50 dark:bg-blue-900/50 text-blue-600 dark:text-blue-400 font-semibold">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
              d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z">
            </path>
          </svg>
          Reportes Mensuales
        </router-link>

        <router-link to="/catalogo-articulos"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          active-class="bg-blue-50 dark:bg-blue-900/50 text-blue-600 dark:text-blue-400 font-semibold">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
              d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z">
            </path>
          </svg>
          Catálogo Base
        </router-link>

        

      </nav>

      <div class="p-4 border-t border-gray-200 dark:border-gray-700">
        <div class="p-6 flex items-center gap-3 border-b border-gray-200 dark:border-gray-700">
          <img src="@/assets/logo-transparente.png" alt="Logo SIA" class="h-10 w-auto" />
          <div class="flex flex-col">
            <h1 class="text-xl font-bold text-gray-900 dark:text-white leading-tight">
              ALMACEN - CJ
            </h1>
            <p class="text-xs text-gray-500 dark:text-gray-400">Sistema DE ALMACEN</p>
            <p class="text-xs text-gray-500 dark:text-gray-400">Consejería Jurídica</p>
          </div>
        </div>

        <button @click="cerrarSesion"
          class="w-full flex items-center justify-center gap-2 bg-red-50 hover:bg-red-100 dark:bg-red-900/20 dark:hover:bg-red-900/40 text-red-600 dark:text-red-400 font-semibold py-2 px-4 rounded-lg transition-colors">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
          </svg>
          Cerrar Sesión
        </button>
      </div>
    </aside>

    <div class="flex-1 flex flex-col min-w-0">

      <header
        class="md:hidden bg-white dark:bg-gray-800 shadow-sm border-b border-gray-200 dark:border-gray-700 px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <img src="@/assets/logo-transparente.png" alt="Logo SIA" class="h-8 w-auto" />
          <h1 class="text-md font-bold text-gray-800 dark:text-white leading-tight">
            Sistema de Almacen CJ
          </h1>
        </div>
        <button @click="isMobileMenuOpen = true"
          class="p-2 rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
        </button>
      </header>

      <main class="flex-1 overflow-y-auto overscroll-none p-4 md:p-8">
        <router-view />
      </main>

      <footer
        class="shrink-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 px-4 md:px-8 py-3 flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-gray-500 dark:text-gray-400 z-10 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)] dark:shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.2)]">
        <div>
          <span class="font-bold text-gray-700 dark:text-gray-300">SIA - CJ</span> &copy; 2026. Versión 1.0.
        </div>

        <div class="flex items-center gap-2">
          <span>Desarrollado por <span class="font-semibold text-blue-600 dark:text-blue-400">cesarjam94</span></span>

          <a href="https://github.com/CesarJam/SIA-CJ" target="_blank" rel="noopener noreferrer"
            class="text-gray-500 hover:text-gray-900 dark:hover:text-white transition-colors"
            title="Ver perfil de GitHub">
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
              <path fill-rule="evenodd"
                d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                clip-rule="evenodd" />
            </svg>
          </a>
        </div>
      </footer>

    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { authService } from '@/services/authService'
import { perfilService } from '@/services/perfilService'
import { useToast } from '@/composables/useToast'
import { supabase } from '@/supabase'

const router = useRouter()
const route = useRoute()
const toast = useToast()

// Estado responsivo y de carga
const isMobileMenuOpen = ref(false)
const uploadingAvatar = ref(false)
const fileInput = ref(null)

// Datos del usuario
const userRole = ref(route.meta.userRole || 'cliente')
const userSecciones = ref(route.meta.userSecciones || [])
const userProfile = ref({
  name: 'Cargando...',
  avatar: 'https://ui-avatars.com/api/?name=Usuario&background=random'
})

// === CARGA INICIAL ===
onMounted(async () => {
  try {
    const session = await authService.getSession()
    if (session?.user) {
      const metadata = session.user.user_metadata
      userProfile.value.name = metadata.display_name || metadata.full_name || metadata.name || session.user.email
      
      let rawAvatar = metadata.avatar_url || metadata.picture

      // 1. LIMPIEZA AUTOMÁTICA: Si el usuario ya tiene una IP quemada en la BD, extraemos solo la ruta
      if (rawAvatar && rawAvatar.includes('/storage/v1/object/public/avatars/')) {
          rawAvatar = rawAvatar.split('/storage/v1/object/public/avatars/')[1]
      }

      // 2. CONSTRUCCIÓN DINÁMICA DE LA URL
      if (rawAvatar) {
          if (rawAvatar.startsWith('http')) {
              userProfile.value.avatar = rawAvatar
          } else {
              // Si es una ruta de nuestro bucket, le pedimos a Supabase la URL actual (respetará Tailscale o Local)
              const { data } = supabase.storage.from('avatars').getPublicUrl(rawAvatar)
              userProfile.value.avatar = data.publicUrl
          }
      } else {
          // Fallback al avatar generado
          userProfile.value.avatar = `https://ui-avatars.com/api/?name=${userProfile.value.name}&background=random`
      }
    }
  } catch (error) {
    console.error("Error al obtener la sesión en el Dashboard:", error)
  }
})

// === LÓGICA DE SUBIDA DE IMAGEN (REFACTORIZADA) ===
const triggerFileInput = () => {
  if (!uploadingAvatar.value) {
    fileInput.value.click()
  }
}

const subirAvatar = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  // Validar que sea imagen y menor a 2MB
  if (!file.type.startsWith('image/')) {
    return toast.error('Por favor, selecciona un archivo de imagen válido.')
  }
  if (file.size > 2 * 1024 * 1024) {
    return toast.error('La imagen debe pesar menos de 2MB.')
  }

  uploadingAvatar.value = true

  try {
    const session = await authService.getSession()
    const user = session?.user
    if (!user) throw new Error('No hay sesión activa')

    // 1. Recibimos el filePath del servicio
    const filePath = await perfilService.actualizarAvatar(file, user.id)

    // 2. Construimos la URL pública dinámicamente con la IP de la red actual
    const { data } = supabase.storage.from('avatars').getPublicUrl(filePath)

    // 3. Actualizamos la interfaz
    userProfile.value.avatar = data.publicUrl
    toast.success('Foto de perfil actualizada correctamente')

  } catch (error) {
    console.error('Error subiendo avatar:', error)
    toast.error('Error al subir imagen. Verifica que el bucket "avatars" exista y sea público.')
  } finally {
    uploadingAvatar.value = false
    event.target.value = '' // Limpiar el input
  }
}

// Cerramos el menú móvil automáticamente al cambiar de ruta
router.afterEach(() => {
  isMobileMenuOpen.value = false
})

const cerrarSesion = async () => {
  try {
    await authService.logout()
    router.push('/login')
  } catch (error) {
    console.error("Error al cerrar sesión:", error)
  }
}
</script>

<style scoped>
/* Animación de transición suave entre vistas */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>