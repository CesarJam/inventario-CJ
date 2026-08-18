<template>
  <transition
    enter-active-class="ease-out duration-300"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="ease-in duration-200"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div v-if="isOpen" class="fixed inset-0 z-[60] flex items-center justify-center p-4 sm:p-6">
      
      <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" @click="$emit('cancel')"></div>
      
      <transition
        enter-active-class="ease-out duration-300"
        enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        enter-to-class="opacity-100 translate-y-0 sm:scale-100"
        leave-active-class="ease-in duration-200"
        leave-from-class="opacity-100 translate-y-0 sm:scale-100"
        leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      >
        <div v-if="isOpen" class="relative bg-white dark:bg-gray-800 rounded-3xl shadow-2xl w-full max-w-sm p-6 sm:p-8 text-center transform transition-all border border-gray-100 dark:border-gray-700">
           
           <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-red-50 dark:bg-red-900/30 mb-5 border-[6px] border-red-100 dark:border-red-900/20">
             <svg class="h-8 w-8 text-red-600 dark:text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
               <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
             </svg>
           </div>
           
           <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">{{ title }}</h3>
           <p class="text-sm text-gray-500 dark:text-gray-400 mb-8">{{ message }}</p>
           
           <div class="flex flex-col-reverse sm:flex-row gap-3">
             <button 
               @click="$emit('cancel')" 
               class="w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 rounded-xl font-semibold hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors focus:outline-none focus:ring-2 focus:ring-gray-200"
             >
               {{ cancelText }}
             </button>
             <button 
               @click="$emit('confirm')" 
               class="w-full px-4 py-3 bg-red-600 text-white rounded-xl font-bold hover:bg-red-700 transition-all shadow-md hover:shadow-lg transform active:scale-95 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800"
             >
               {{ confirmText }}
             </button>
           </div>

        </div>
      </transition>
    </div>
  </transition>
</template>

<script setup>

import { onMounted, onUnmounted } from 'vue'

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  title: { type: String, default: '¿Estás seguro?' },
  message: { type: String, default: 'Esta acción no se puede deshacer.' },
  confirmText: { type: String, default: 'Eliminar' },
  cancelText: { type: String, default: 'Cancelar' }
})

const emit = defineEmits(['confirm', 'cancel'])

// Función para manejar el teclado
const handleKeydown = (e) => {
  if (props.isOpen && e.key === 'Escape') {
    emit('cancel')
  }
}

onMounted(() => {
  document.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
})
</script>