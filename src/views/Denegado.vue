<template>
  <div class="flex items-center justify-center min-h-screen p-4 fade-in">
    <div class="w-full max-w-md p-8 space-y-6 bg-white dark:bg-gray-800 rounded-2xl shadow-2xl text-center">
      <h1 class="text-3xl font-bold text-red-600 dark:text-red-400">Acceso Denegado</h1>
      <p class="text-lg text-gray-600 dark:text-gray-300">
        Lo sentimos, no tienes los permisos necesarios o tu correo no está registrado en el sistema.
      </p>
      <button 
        @click="volverAlInicio" 
        class="w-full bg-gray-600 hover:bg-gray-700 text-white font-bold py-3 px-4 rounded-lg mt-4 transition duration-300"
      >
        Volver al Login
      </button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const volverAlInicio = () => {
  router.push('/login')
}
</script>

<style scoped>
.fade-in {
  animation: fadeIn 0.5s ease-in-out;
}
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
</style>