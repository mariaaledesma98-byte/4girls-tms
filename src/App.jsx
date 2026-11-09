import { useEffect, useMemo, useState } from 'react';
import { supabase } from './supabase.js';
import pedidosEjemplo from './data/pedidos.json';
import productosEjemplo from './data/productos.json';
import MapaEntregas from './MapaEntregas.jsx';
import { TablaArticulos, TablaPedidos } from './Tablas.jsx';
import { fmt } from './util.js';

// Trae los datos desde Supabase. Si Supabase no está configurado (o falla),
// usa los datos de ejemplo del proyecto y lo avisa en pantalla.
function useDatos() {
  const [datos, setDatos] = useState({ pedidos: [], productos: [], origen: 'cargando', error: '' });

  useEffect(() => {
    let vivo = true;
    async function cargar() {
      if (!supabase) {
        setDatos({ pedidos: pedidosEjemplo, productos: productosEjemplo, origen: 'ejemplo', error: '' });
        return;
      }
      const [p, a] = await Promise.all([
        supabase.from('pedidos').select('*').order('np'),
        supabase.from('productos').select('*').order('sku'),
      ]);
      if (!vivo) return;
      if (p.error || a.error) {
        const mensaje = (p.error || a.error).message;
        console.error('Error al leer Supabase:', p.error || a.error);
        setDatos({ pedidos: pedidosEjemplo, productos: productosEjemplo, origen: 'error', error: mensaje });
        return;
      }
      console.log('Pedidos que llegaron desde Supabase:', p.data); // para comprobar que los datos llegan
      setDatos({ pedidos: p.data, productos: a.data, origen: 'supabase', error: '' });
    }
    cargar();
    return () => {
      vivo = false;
    };
  }, []);

  return datos;
}

function Indicadores({ pedidos }) {
  const k = useMemo(() => {
    const total = pedidos.length;
    const cuenta = (e) => pedidos.filter((p) => p.categoria === e).length;
    const entregados = cuenta('Entregado');
    const abiertos = pedidos.filter((p) => p.categoria === 'Pendiente' || p.categoria === 'En camino');
    return {
      total,
      entregados,
      pct: total ? Math.round((entregados / total) * 100) : 0,
      abiertos: abiertos.length,
      palletsAbiertos: abiertos.reduce((a, p) => a + Number(p.valor), 0),
      rechazados: cuenta('Rechazado'),
    };
  }, [pedidos]);

  const items = [
    { titulo: 'Pedidos registrados', valor: fmt(k.total), nota: 'notas de pedido en total' },
    { titulo: 'Entregados', valor: fmt(k.entregados), nota: `${k.pct}% del total` },
    { titulo: 'Pendientes o en camino', valor: fmt(k.abiertos), nota: `${fmt(k.palletsAbiertos)} pallets por entregar` },
    { titulo: 'Rechazados', valor: fmt(k.rechazados), nota: 'el cliente no aceptó el pedido' },
  ];

  return (
    <div className="kpis">
      {items.map((i) => (
        <div className="kpi" key={i.titulo}>
          <div className="kpi-titulo">{i.titulo}</div>
          <div className="kpi-valor">{i.valor}</div>
          <div className="kpi-nota">{i.nota}</div>
        </div>
      ))}
    </div>
  );
}

const TABS = [
  { id: 'mapa', label: 'Mapa de entregas' },
  { id: 'pedidos', label: 'Notas de pedido' },
  { id: 'articulos', label: 'Maestro de artículos' },
];

export default function App() {
  const { pedidos, productos, origen, error } = useDatos();
  const [tab, setTab] = useState('mapa');

  return (
    <div className="app">
      <header className="cabecera">
        <div className="marca">
          <div className="logo" aria-hidden="true">
            <i style={{ background: '#7C97FF' }} />
            <i style={{ background: '#FFC83D' }} />
            <i style={{ background: '#5FD3A5' }} />
            <i style={{ background: '#FF8E7A' }} />
          </div>
          <div>
            <h1>4 Girls TMS</h1>
            <p>Mapa de entregas: de dónde sale la mercadería, a dónde va y si llegó</p>
          </div>
        </div>
        <div className={`estado-datos ${origen}`}>
          {origen === 'cargando' && 'Cargando datos…'}
          {origen === 'supabase' && `Datos en vivo desde Supabase · ${pedidos.length} registros`}
          {origen === 'ejemplo' && 'Datos de ejemplo del proyecto (todavía sin conexión a Supabase)'}
          {origen === 'error' && `No se pudo leer Supabase (${error}). Se muestran datos de ejemplo.`}
        </div>
      </header>

      <Indicadores pedidos={pedidos} />

      <nav className="tabs" aria-label="Secciones">
        {TABS.map((t) => (
          <button key={t.id} className={tab === t.id ? 'tab on' : 'tab'} onClick={() => setTab(t.id)}>
            {t.label}
          </button>
        ))}
      </nav>

      <main>
        {tab === 'mapa' && <MapaEntregas pedidos={pedidos} />}
        {tab === 'pedidos' && <TablaPedidos pedidos={pedidos} />}
        {tab === 'articulos' && <TablaArticulos productos={productos} />}
      </main>

      <footer className="pie">
        PoC · Supabase + React/Vite + deck.gl + Vercel · Datos de ejemplo: clientes y direcciones inventados,
        coordenadas aproximadas por localidad.
      </footer>
    </div>
  );
}
