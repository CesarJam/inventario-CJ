import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import { fileURLToPath, URL } from 'node:url'
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [
    vue(),
    tailwindcss(),
    VitePWA({
      registerType: 'autoUpdate', // Actualiza la app automáticamente cuando detecta cambios
      devOptions: {
        enabled: false // Permite probar la PWA mientras estás en modo 'npm run dev'
      },
      manifest: {
        name: 'Sistema Integral de  Archivos - CJ',
        short_name: 'SIA-CJ',
        description: 'Bandeja y gestor de tareas de la Consejería Jurídica',
        theme_color: '#0e0000', // Color de la barra de estado del celular
        background_color: '#000000',
        display: 'standalone', // Hace que se vea como una app nativa, sin barra de direcciones
        icons: [
          {
            src: '/pwa-192x192.png',
            sizes: '192x192',
            type: 'image/png'
          },
          {
            src: '/pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'any maskable'
          }
        ]
      }
    })
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    proxy: {
      // Intercepta las llamadas que empiecen con /api-proceso
      '/api-proceso': {
        target: 'https://www.proceso.com.mx',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api-proceso/, '')
      }
    }
  }
})