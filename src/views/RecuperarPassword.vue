<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 dark:bg-gray-900 p-4">
    <div class="max-w-md w-full bg-white dark:bg-gray-800 rounded-xl shadow-lg p-8">
      
      <div class="text-center mb-8">
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Recuperar Contraseña</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
          Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.
        </p>
      </div>

      <div v-if="mensaje.texto" :class="[
        'mb-6 p-4 rounded-lg text-sm font-medium',
        mensaje.tipo === 'exito' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'
      ]">
        {{ mensaje.texto }}
      </div>

      <form @submit.prevent="solicitarRecuperacion" class="space-y-5" v-if="!correoEnviado">
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Correo Electrónico</label>
          <input 
            v-model="email" 
            type="email" 
            required
            placeholder="tu@correo.com" 
            class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 dark:text-white transition-colors"
          >
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
          {{ cargando ? 'Enviando enlace...' : 'Enviar enlace de recuperación' }}
        </button>
        
        <p class="text-center text-sm mt-4">
          <router-link to="/login" class="text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300 font-semibold flex items-center justify-center gap-1 transition-colors">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Volver al inicio de sesión
          </router-link>
        </p>
      </form>

      <div v-else class="text-center mt-4">
        <router-link to="/login" class="inline-block bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-800 dark:text-white font-semibold py-2.5 px-6 rounded-lg transition-colors">
          Entendido, volver al Login
        </router-link>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
// --- IMPORTAMOS EL SERVICIO DE AUTENTICACIÓN ---
import { authService } from '@/services/authService'

const email = ref('')
const cargando = ref(false)
const correoEnviado = ref(false)
const mensaje = ref({ texto: '', tipo: '' })

const solicitarRecuperacion = async () => {
  try {
    cargando.value = true
    mensaje.value = { texto: '', tipo: '' }

    const urlRedireccion = `${window.location.origin}/actualizar-password`

    // --- LLAMADA LIMPIA AL SERVICIO ---
    await authService.resetPassword(email.value, urlRedireccion)

    correoEnviado.value = true
    
    mensaje.value = {
      texto: 'Si el correo está registrado en nuestro sistema, recibirás un enlace para restablecer tu contraseña en unos minutos.',
      tipo: 'exito'
    }

  } catch (error) {
    console.error(error)
    mensaje.value = {
      texto: 'Ocurrió un error al intentar enviar la solicitud. Intenta de nuevo más tarde.',
      tipo: 'error'
    }
  } finally {
    cargando.value = false
  }
}
</script>