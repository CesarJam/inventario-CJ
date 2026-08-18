import { createRouter, createWebHistory } from 'vue-router';
import Dashboard from '@/views/Dashboard.vue';
import Home from '@/views/modules/Home.vue';
import Inventario from '@/views/modules/Inventario.vue';
import Registro from '@/views/Registro.vue';
import RecuperarPassword from '@/views/RecuperarPassword.vue';
import ActualizarPassword from '@/views/ActualizarPassword.vue';

// Componentes con carga perezosa (Lazy Loading)
const Login = () => import('@/views/Login.vue');
const Denegado = () => import('@/views/Denegado.vue');

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { requiresGuest: true },
  },
  {
    path: '/registro',
    name: 'Registro',
    component: Registro,
    meta: { requiresAuth: false },
  },
  {
    path: '/denegado',
    name: 'Denegado',
    component: Denegado,
  },
  {
    path: '/recuperar-password',
    name: 'RecuperarPassword',
    component: RecuperarPassword,
    meta: { requiresAuth: false },
  },
  {
    path: '/actualizar-password',
    name: 'ActualizarPassword',
    component: ActualizarPassword,
    meta: { requiresAuth: false },
  },
  {
    path: '/',
    component: Dashboard,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'Home',
        component: Home,
      },
      {
        path: 'inventario',
        name: 'Inventario',
        component: Inventario,
        meta: { requiresAuth: true },
      },
      {
        path: 'reportes-inventario',
        name: 'ReportesInventario',
        // Usamos importación perezosa (lazy-load) para no cargar la vista hasta que se use
        component: () => import('@/views/modules/ReportesInventario.vue'),
        meta: { requiresAuth: true },
      },
      {
        path: 'catalogo-articulos',
        name: 'CatalogoArticulos',
        component: () => import('@/views/modules/CatalogoArticulos.vue'),
        meta: { requiresAuth: true },
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;