
Inventario CJ 📦
Sistema web integral para el control y gestión de inventario de materiales (Oficina y Limpieza) desarrollado para la Consejería Jurídica del Poder Ejecutivo del Estado de Guerrero.

Esta aplicación permite llevar un seguimiento exacto del stock anual, agilizar el registro de entradas y salidas (vales), y generar reportes históricos automatizados.

🚀 Características Principales
Panel de Control (Dashboard): Visualización rápida de métricas clave, artículos más entregados del mes y alertas automáticas de stock crítico.

Catálogo Base Visual: Gestión (CRUD) de artículos con soporte para carga de imágenes mediante Supabase Storage.

Gestión de Ejercicios Anuales: Cálculo dinámico de stock filtrado por año en curso, previniendo alteraciones en historiales de años anteriores.

Control de Movimientos:

Registro ágil de entradas (Stock inicial e ingresos esporádicos).

Control de salidas mediante vales y dotaciones mensuales con validación estricta de stock máximo disponible.

Reportes Exportables: Generación de reportes mensuales de entradas y salidas exportables a PDF (con jsPDF) y CSV (formateado con UTF-8 y delimitador ; para compatibilidad nativa con Excel en la región).

Soporte PWA: Configurado para funcionar como Aplicación Web Progresiva, permitiendo su instalación como aplicación nativa en escritorio.

🛠️ Tecnologías Utilizadas
Frontend:

Vue 3 (Composition API & <script setup>)

Vite (Bundler y entorno de desarrollo)

Tailwind CSS (Diseño y utilidades CSS)

vite-plugin-pwa (Soporte Offline y PWA)

jsPDF & jsPDF-AutoTable (Generación de documentos)

Backend & Base de Datos:

Supabase

PostgreSQL (Vistas SQL, Triggers y cruces relacionales).

Supabase Storage (Buckets públicos para imágenes).

Row Level Security (RLS) policies.

⚙️ Requisitos Previos
Node.js (v18 o superior recomendado)

NPM (v8 o superior, utilizando --legacy-peer-deps si existen conflictos con plugins PWA)

Cuenta y proyecto configurado en Supabase.

💻 Instalación y Ejecución Local
Clonar el repositorio:

Bash
git clone https://github.com/tu-usuario/inventario-CJ.git
cd inventario-CJ
Instalar dependencias:
Debido a resoluciones estrictas en versiones recientes de NPM con dependencias de desarrollo (vite-plugin-pwa), se recomienda usar:

Bash
npm install --legacy-peer-deps
Configurar variables de entorno:
Crea un archivo .env en la raíz del proyecto y agrega tus credenciales de Supabase:

Fragmento de código
VITE_SUPABASE_URL=tu_url_de_supabase
VITE_SUPABASE_ANON_KEY=tu_anon_key_publica
Levantar el servidor de desarrollo:

Bash
npm run dev
La aplicación estará disponible en http://localhost:5173.

Compilar para producción:

Bash
npm run build
🗄️ Configuración de Supabase (Database & Storage)
Para que el sistema funcione correctamente, la base de datos de Supabase requiere:

Esquema: Un esquema dedicado llamado inventario con las tablas:

articulos (con columna imagen_url)

entradas_material

salidas_material

areas_solicitantes

Vistas SQL: La lógica de negocio depende de vistas calculadas directamente en PostgreSQL (ej. vista_inventario_anual y vista_reporte_salidas) para agilizar el rendimiento del Frontend.

Storage: Un bucket público llamado articulos configurado con políticas RLS (Row Level Security) que permitan las operaciones INSERT, UPDATE, DELETE y SELECT para manejar las imágenes del catálogo.