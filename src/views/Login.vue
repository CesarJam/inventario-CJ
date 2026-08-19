<template>
  <div class="flex flex-col items-center justify-center min-h-screen p-4 bg-gradient-to-br from-gray-100 to-gray-300 dark:from-gray-900 dark:to-gray-800 fade-in relative">
    
    <div class="w-full max-w-md mx-auto p-8 bg-white dark:bg-gray-800 rounded-3xl shadow-2xl border border-gray-100 dark:border-gray-700 text-center relative z-10">
      
      <div class="flex justify-center mb-6">
        <div class="bg-blue-100 dark:bg-blue-900/30 p-4 rounded-full">
          <img src="@/assets/inventario-logo.jpg" class="h-16 w-auto" alt="Logo">
        </div>
      </div>

      <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight mb-2">
          Inventario-CJ
      </h1>
      <h2 class="text-2xl font-extrabold text-gray-900 dark:text-white tracking-tight mb-6">Inventario-CJ</h2>
      
      <form @submit.prevent="iniciarSesion" class="space-y-4 text-left">
        
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Correo Electrónico</label>
          <input 
            id="email" 
            v-model="email" 
            type="email" 
            required
            @input="errorMessage = ''"
            class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-colors"
            placeholder="usuario@ejemplo.com"
          >
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Contraseña</label>
          <input 
            id="password" 
            v-model="password" 
            type="password" 
            required
            @input="errorMessage = ''"
            class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-colors"
            placeholder="••••••••"
          >
        </div>
        <div class="flex justify-end mt-1">
          <router-link to="/recuperar-password" class="text-sm font-semibold text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300 transition-colors">
            ¿Olvidaste tu contraseña?
          </router-link>
        </div>

        <div v-if="errorMessage" class="p-3 bg-red-50 dark:bg-red-900/30 border border-red-200 dark:border-red-800 rounded-lg flex items-center gap-2 text-red-600 dark:text-red-400 text-sm transition-all">
          <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          <span>{{ errorMessage }}</span>
        </div>

        <button 
          type="submit" 
          :disabled="cargando"
          class="w-full mt-4 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-semibold py-3.5 px-4 rounded-xl shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all transform hover:-translate-y-0.5 duration-300 flex items-center justify-center"
        >
          <span v-if="cargando" class="flex items-center gap-2">
            <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Iniciando sesión...
          </span>
          <span v-else>
            Ingresar al Sistema
          </span>
        </button>
      </form>

      <div class="mt-8 pt-6 border-t border-gray-200 dark:border-gray-700">
        <p class="text-sm text-gray-600 dark:text-gray-400">
          ¿No tienes cuenta? <br/>
          <router-link to="/registro" class="font-semibold text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300 transition-colors mt-1 inline-block">
            Regístrate aquí para solicitar acceso
          </router-link>
        </p>
      </div>
    </div>

    <div class="absolute bottom-0 text-center w-full z-0">
      <footer class="shrink-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 px-4 md:px-8 py-3 flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-gray-500 dark:text-gray-400 z-10 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)] dark:shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.2)]">
        <div>
          <span class="font-bold text-gray-700 dark:text-gray-300">Inventario - CJ</span> &copy; 2026. Versión 1.0.
        </div>
        
        <div class="flex items-center gap-2">
          <span>Desarrollado por <span class="font-semibold text-blue-600 dark:text-blue-400">cesarjam94</span></span>
          
          <a href="https://github.com/CesarJam/SIA-CJ" target="_blank" rel="noopener noreferrer" 
             class="text-gray-500 hover:text-gray-900 dark:hover:text-white transition-colors"
             title="Ver perfil de GitHub">
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
              <path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd" />
            </svg>
          </a>
        </div>
      </footer>
    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService'
const errorMessage = ref('')

const router = useRouter()
const email = ref('')
const password = ref('')
const cargando = ref(false)

const iniciarSesion = async () => {
  errorMessage.value = ''
  try {
    cargando.value = true
    await authService.loginWithEmail(email.value, password.value)
    router.push('/')
    
  } catch (error) {
    console.error("Error al iniciar sesión:", error.message)
    errorMessage.value = "Credenciales incorrectas. Verifica tu correo y contraseña."
  } finally {
    cargando.value = false
  }
}
</script>

<style scoped>
.fade-in {
  animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>