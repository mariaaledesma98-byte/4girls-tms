// Estados de un pedido y su color (rojo-verde-azul) para el mapa y las etiquetas.
export const ESTADOS = ['Pendiente', 'En camino', 'Entregado', 'Rechazado'];

export const COLOR = {
  Pendiente: [91, 100, 117],
  'En camino': [242, 176, 30],
  Entregado: [22, 122, 67],
  Rechazado: [198, 40, 40],
};

export const hex = (estado) => {
  const c = COLOR[estado] || [0, 0, 0];
  return `rgb(${c[0]}, ${c[1]}, ${c[2]})`;
};

// Centro logístico: de acá sale toda la mercadería.
export const CENTRO = {
  nombre: 'Centro logístico',
  direccion: 'María C. Voena 1750, El Talar',
  longitud: -58.64591,
  latitud: -34.46815,
};

export const fmt = (n, d = 0) =>
  Number(n).toLocaleString('es-AR', { minimumFractionDigits: d, maximumFractionDigits: d });

export const fechaCorta = (iso) => {
  if (!iso) return '—';
  const [a, m, d] = iso.split('-');
  return `${d}/${m}/${a}`;
};

// Escapa texto antes de ponerlo en el globo de información del mapa.
export const esc = (s) =>
  String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
