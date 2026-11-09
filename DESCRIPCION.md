1. **Problema:** en la operación logística de 4 Girls TMS no se ve en un mapa a dónde van los pedidos, cuáles llegaron y dónde se demora.
2. **Datos:** 40 notas de pedido (cliente, estado, latitud, longitud, pallets, fecha, demora) y 20 artículos, guardados en Supabase.
3. **Indicadores:** pedidos registrados, % entregados, pallets pendientes o en camino y pedidos rechazados, calculados desde Supabase.
4. **Mapa:** deck.gl sobre React/Vite con puntos por estado, concentración de pedidos y demoras; el tooltip muestra cliente, estado y pallets.
5. **Decisión que apoya:** priorizar rutas y zonas con más pallets pendientes y más demora, partiendo del centro logístico de El Talar.
