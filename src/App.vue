<template>
  <div class="min-h-screen bg-gray-50 text-gray-900 dark:bg-gray-900 dark:text-gray-100 transition-colors duration-300">
    <router-view />
    <ToastContainer />
  </div>
</template>

<script setup>
import ToastContainer from '@/components/ToastContainer.vue'
</script>