# 4 Girls TMS — PoC de datos georreferenciados

Mapa de entregas de un centro logístico (María C. Voena 1750, El Talar): de dónde sale la mercadería, a dónde va y si llegó.

**Stack:** Supabase (datos) · React + Vite · deck.gl (mapa) · Vercel (publicación)

## Qué muestra
- 4 indicadores calculados con los datos de Supabase: pedidos registrados, entregados (%), pendientes/en camino (y pallets por entregar), rechazados.
- Mapa interactivo deck.gl con 3 vistas: puntos por estado, concentración de pedidos y demoras. Filtros por estado.
- Tooltip al pasar el mouse: nombre del cliente, categoría (estado) y valor (pallets).
- Tabla de notas de pedido y maestro de artículos (20 SKU).
- Dataset: 40 pedidos (datos inventados, coordenadas aproximadas por localidad).

## Paso a paso para publicarlo
1. **Supabase:** creá una cuenta en supabase.com → New project.
2. En **SQL Editor** pegá todo el contenido de `supabase/schema.sql` y apretá Run. Crea las tablas y carga los datos.
3. En **Project Settings → API** copiá la *Project URL* y la clave *anon public*.
4. **GitHub:** creá un repositorio nuevo y subí esta carpeta (sin `node_modules`; ya está en `.gitignore`).
5. **Vercel:** vercel.com → Add New → Project → importá el repositorio (Framework: Vite).
6. En *Environment Variables* cargá `VITE_SUPABASE_URL` y `VITE_SUPABASE_ANON_KEY` con los valores del paso 3.
7. Deploy. Vercel te da la URL pública.
8. Abrí la URL: el cartel de arriba tiene que decir **"Datos en vivo desde Supabase · 40 registros"**. Sacá la captura de pantalla.

Si el cartel dice "Datos de ejemplo", faltan las variables (revisá el paso 6 y volvé a hacer Deploy).

## Probar en tu computadora (opcional)
```
npm install
cp .env.example .env     # completá las dos variables
npm run dev
```

## Cambiar el dataset
Editá los INSERT de `supabase/schema.sql` (o importá `data/pedidos.csv` desde Table Editor). Columnas clave: nombre, categoría, latitud, longitud, valor.

## Descripción (5 líneas) para la entrega
Está en `DESCRIPCION.md`.

## Más adelante: Odoo
La idea es sincronizar desde Odoo (sale.order, stock.picking, res.partner) hacia Supabase con una función de servidor en Vercel; el mapa no cambia.
