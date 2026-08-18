<template>
  <div class="fixed bottom-4 right-4 z-[100] flex flex-col gap-3 pointer-events-none">
    
    <TransitionGroup 
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="transform translate-y-4 opacity-0 sm:translate-y-0 sm:translate-x-4"
      enter-to-class="transform translate-y-0 opacity-100 sm:translate-x-0"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="transform opacity-100 scale-100"
      leave-to-class="transform opacity-0 scale-95"
    >
      <div 
        v-for="toast in toasts" 
        :key="toast.id" 
        class="pointer-events-auto flex items-center w-full max-w-sm bg-white dark:bg-gray-800 shadow-xl rounded-lg border-l-4 overflow-hidden"
        :class="getStyles(toast.type).border"
      >
        <div class="flex items-center justify-center w-12 h-full bg-gray-50 dark:bg-gray-900/50">
          <svg class="w-6 h-6" :class="getStyles(toast.type).iconColor" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path v-if="toast.type === 'success'" stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            <path v-if="toast.type === 'error'" stroke-linecap="round" stroke-linejoin="round" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
            <path v-if="toast.type === 'info'" stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        
        <div class="px-4 py-3 flex-1">
          <p class="text-sm font-semibold text-gray-800 dark:text-gray-200">{{ toast.message }}</p>
        </div>

        <button @click="removeToast(toast.id)" class="px-3 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 transition-colors">
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
        </button>
      </div>
    </TransitionGroup>

  </div>
</template>

<script setup>
import { useToast } from '@/composables/useToast'

// Consumimos el estado global
const { toasts, removeToast } = useToast()

// Función para mapear colores de Tailwind según el tipo de alerta
const getStyles = (type) => {
  switch (type) {
    case 'success': return { border: 'border-green-500', iconColor: 'text-green-500' }
    case 'error':   return { border: 'border-red-500', iconColor: 'text-red-500' }
    case 'info':    return { border: 'border-blue-500', iconColor: 'text-blue-500' }
    default:        return { border: 'border-gray-500', iconColor: 'text-gray-500' }
  }
}
</script>