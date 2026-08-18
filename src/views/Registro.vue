<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 dark:bg-gray-900 p-4">
    <div class="max-w-md w-full bg-white dark:bg-gray-800 rounded-xl shadow-lg p-8">
      
      <div class="text-center mb-8">
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Crear una cuenta</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
          Regístrate para solicitar acceso al sistema
        </p>
      </div>

      <div v-if="mensaje.texto" :class="[
        'mb-6 p-4 rounded-lg text-sm font-medium',
        mensaje.tipo === 'exito' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'
      ]">
        {{ mensaje.texto }}
      </div>

      <form @submit.prevent="registrarUsuario" class="space-y-5" v-if="!registroExitoso">
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nombre Completo</label>
          <input 
            v-model="formulario.nombre" 
            type="text" 
            required
            placeholder="Ej. Juan Pérez" 
            class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 dark:text-white transition-colors"
          >
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Correo Electrónico</label>
          <input 
            v-model="formulario.email" 
            type="email" 
            required
            placeholder="tu@correo.com" 
            class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 dark:text-white transition-colors"
          >
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Contraseña</label>
          <div class="relative">
            <input 
              v-model="formulario.password" 
              :type="mostrarPassword ? 'text' : 'password'" 
              required
              placeholder="Mínimo 6 caracteres" 
              minlength="6"
              class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 dark:text-white transition-colors pr-12"
            >
            <button 
              type="button" 
              @click="mostrarPassword = !mostrarPassword"
              class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 focus:outline-none transition-colors"
            >
              <svg v-if="!mostrarPassword" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a9.978 9.978 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.542 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
              </svg>
            </button>
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Confirmar Contraseña</label>
          <div class="relative">
            <input 
              v-model="formulario.confirmarPassword" 
              :type="mostrarConfirmarPassword ? 'text' : 'password'" 
              required
              placeholder="Vuelve a escribir tu contraseña" 
              minlength="6"
              class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 dark:text-white transition-colors pr-12"
            >
            <button 
              type="button" 
              @click="mostrarConfirmarPassword = !mostrarConfirmarPassword"
              class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 focus:outline-none transition-colors"
            >
              <svg v-if="!mostrarConfirmarPassword" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a9.978 9.978 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.542 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
              </svg>
            </button>
          </div>
        </div>

        <button 
          type="submit" 
          :disabled="cargando"
          class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition-colors flex justify-center items-center disabled:opacity-70 disabled:cursor-not-allowed"
        >
          <svg v-if="cargando" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          {{ cargando ? 'Registrando...' : 'Registrarse' }}
        </button>
        
        <p class="text-center text-sm text-gray-600 dark:text-gray-400 mt-4">
          ¿Ya tienes cuenta? 
          <router-link to="/login" class="text-blue-600 hover:text-blue-700 font-semibold">Inicia sesión aquí</router-link>
        </p>

      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
// --- IMPORTAMOS EL SERVICIO DE AUTENTICACIÓN ---
import { authService } from '@/services/authService' 

const router = useRouter()
const formulario = ref({
  nombre: '',
  email: '',
  password: '',
  confirmarPassword: '' 
})

// Variables para controlar la visibilidad de las contraseñas
const mostrarPassword = ref(false)
const mostrarConfirmarPassword = ref(false)

const cargando = ref(false)
const registroExitoso = ref(false)
const mensaje = ref({ texto: '', tipo: '' })

const registrarUsuario = async () => {
  try {
    // Validación previa para asegurar que las contraseñas coinciden
    if (formulario.value.password !== formulario.value.confirmarPassword) {
      mensaje.value = {
        texto: 'Las contraseñas no coinciden. Por favor, verifícalas.',
        tipo: 'error'
      }
      return // Detenemos la ejecución si no coinciden
    }

    cargando.value = true
    mensaje.value = { texto: '', tipo: '' }

    // --- LLAMADA LIMPIA AL SERVICIO ---
    await authService.registerUser(
      formulario.value.email,
      formulario.value.password,
      formulario.value.nombre
    )

    registroExitoso.value = true
    mensaje.value = {
      texto: '¡Registro exitoso! Solicita al administrador del sistema acceso a tu catálogo de tu área. Serás redirigido al sistema en unos segundos...',
      tipo: 'exito'
    }

    setTimeout(() => {
      router.push('/')
    }, 5000)

  } catch (error) {
    console.error(error)
    mensaje.value = {
      texto: error.message === 'User already registered' 
        ? 'Este correo ya está registrado en el sistema.' 
        : 'Ocurrió un error al intentar registrarte. ' + error.message,
      tipo: 'error'
    }
  } finally {
    cargando.value = false
  }
}
</script>
