<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 dark:bg-gray-900 p-4">
    <div class="max-w-md w-full bg-white dark:bg-gray-800 rounded-xl shadow-lg p-8">
      
      <div class="text-center mb-8">
        <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Nueva Contraseña</h2>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
          Ingresa tu nueva contraseña para acceder al sistema.
        </p>
      </div>

      <div v-if="mensaje.texto" :class="[
        'mb-6 p-4 rounded-lg text-sm font-medium',
        mensaje.tipo === 'exito' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'
      ]">
        {{ mensaje.texto }}
      </div>

      <form @submit.prevent="guardarPassword" class="space-y-5" v-if="!actualizacionExitosa">
        
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nueva Contraseña</label>
          <input 
            v-model="nuevaPassword" 
            type="password" 
            required
            placeholder="Mínimo 6 caracteres" 
            minlength="6"
            class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 dark:text-white transition-colors"
          >
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Confirmar Contraseña</label>
          <input 
            v-model="confirmarPassword" 
            type="password" 
            required
            placeholder="Vuelve a escribir la contraseña" 
            minlength="6"
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
          {{ cargando ? 'Actualizando...' : 'Guardar Contraseña' }}
        </button>
      </form>

    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '@/services/authService'

const router = useRouter()
const nuevaPassword = ref('')
const confirmarPassword = ref('')
const cargando = ref(false)
const actualizacionExitosa = ref(false)
const mensaje = ref({ texto: '', tipo: '' })

const guardarPassword = async () => {
  if (nuevaPassword.value !== confirmarPassword.value) {
    mensaje.value = { texto: 'Las contraseñas no coinciden.', tipo: 'error' }
    return
  }

  try {
    cargando.value = true
    mensaje.value = { texto: '', tipo: '' }

    // --- LLAMADA LIMPIA AL SERVICIO ---
    await authService.updatePassword(nuevaPassword.value)

    actualizacionExitosa.value = true
    mensaje.value = {
      texto: '¡Contraseña actualizada con éxito! Redirigiendo al sistema...',
      tipo: 'exito'
    }

    setTimeout(() => {
      router.push('/') // Te lleva al dashboard ya autenticado
    }, 3000)

  } catch (error) {
    console.error(error)
    mensaje.value = {
      texto: 'Hubo un error al actualizar tu contraseña. Es posible que el enlace haya expirado.',
      tipo: 'error'
    }
  } finally {
    cargando.value = false
  }
}
</script>