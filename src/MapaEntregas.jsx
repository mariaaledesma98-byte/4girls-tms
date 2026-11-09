import { useMemo, useState } from 'react';
import DeckGL from '@deck.gl/react';
import { ScatterplotLayer } from '@deck.gl/layers';
import { HeatmapLayer } from '@deck.gl/aggregation-layers';
import { Map } from 'react-map-gl/maplibre';
import 'maplibre-gl/dist/maplibre-gl.css';
import { CENTRO, COLOR, ESTADOS, esc, fmt, fechaCorta, hex } from './util.js';

// Mapa base gratuito de CARTO (no necesita clave).
const MAPA_BASE = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json';

const VISTA_INICIAL = { longitude: -58.55, latitude: -34.58, zoom: 9.3, pitch: 0, bearing: 0 };

const MODOS = [
  { id: 'puntos', label: 'Puntos por estado' },
  { id: 'calor', label: 'Concentración de pedidos' },
  { id: 'demoras', label: 'Demoras' },
];

const AYUDA = {
  puntos: 'Cada punto es un pedido. El color es el estado y el tamaño, la cantidad de pallets.',
  calor: 'Las zonas más rojas concentran más pallets pedidos.',
  demoras: 'Las zonas más rojas tuvieron más horas de demora en las entregas ya realizadas.',
};

export default function MapaEntregas({ pedidos }) {
  const [estado, setEstado] = useState('Todos');
  const [modo, setModo] = useState('puntos');

  const visibles = useMemo(
    () => (estado === 'Todos' ? pedidos : pedidos.filter((p) => p.categoria === estado)),
    [pedidos, estado]
  );

  // Zonas con mayor demora promedio (solo entregas realizadas).
  const zonas = useMemo(() => {
    const acc = {};
    pedidos
      .filter((p) => p.categoria === 'Entregado' && p.demora_horas != null)
      .forEach((p) => {
        const z = (acc[p.localidad] ||= { localidad: p.localidad, suma: 0, n: 0 });
        z.suma += Number(p.demora_horas);
        z.n += 1;
      });
    return Object.values(acc)
      .map((z) => ({ ...z, prom: z.suma / z.n }))
      .sort((a, b) => b.prom - a.prom)
      .slice(0, 5);
  }, [pedidos]);

  const layers = useMemo(() => {
    const pos = (d) => [Number(d.longitud), Number(d.latitud)];
    const capas = [];

    if (modo === 'puntos') {
      capas.push(
        new ScatterplotLayer({
          id: 'pedidos',
          data: visibles,
          pickable: true,
          getPosition: pos,
          getFillColor: (d) => COLOR[d.categoria] || [0, 0, 0],
          getRadius: (d) => 7 + Number(d.valor) * 2.5,
          radiusUnits: 'pixels',
          stroked: true,
          getLineColor: [255, 255, 255],
          getLineWidth: 1.5,
          lineWidthUnits: 'pixels',
          opacity: 0.95,
          updateTriggers: { getFillColor: [estado] },
        })
      );
    } else {
      const base = modo === 'demoras' ? visibles.filter((d) => Number(d.demora_horas) > 0) : visibles;
      capas.push(
        new HeatmapLayer({
          id: 'calor',
          data: base,
          getPosition: pos,
          getWeight: (d) => (modo === 'demoras' ? Number(d.demora_horas) : Number(d.valor)),
          radiusPixels: 70,
          intensity: 1.2,
          threshold: 0.04,
          aggregation: 'SUM',
        }),
        // Puntos chicos para poder pasar el mouse y ver el dato.
        new ScatterplotLayer({
          id: 'pedidos-calor',
          data: base,
          pickable: true,
          getPosition: pos,
          getFillColor: [20, 26, 43, 190],
          getRadius: 4,
          radiusUnits: 'pixels',
        })
      );
    }

    capas.push(
      new ScatterplotLayer({
        id: 'centro',
        data: [CENTRO],
        pickable: true,
        getPosition: pos,
        getFillColor: [20, 26, 43],
        getRadius: 11,
        radiusUnits: 'pixels',
        stroked: true,
        getLineColor: [255, 200, 61],
        getLineWidth: 3,
        lineWidthUnits: 'pixels',
      })
    );
    return capas;
  }, [visibles, modo, estado]);

  // Información que aparece al pasar el mouse por un punto.
  const tooltip = ({ object, layer }) => {
    if (!object) return null;
    const estilo = {
      background: '#161B26',
      color: '#fff',
      fontFamily: 'Inter, system-ui, sans-serif',
      fontSize: '13px',
      lineHeight: '1.45',
      padding: '10px 12px',
      borderRadius: '8px',
      maxWidth: '260px',
    };
    if (layer.id === 'centro') {
      return { html: `<b>${esc(object.nombre)}</b><br/>Sale toda la mercadería<br/>${esc(object.direccion)}`, style: estilo };
    }
    const demora =
      object.demora_horas != null ? `<br/>Demora: ${fmt(object.demora_horas, 1)} horas` : '';
    return {
      html:
        `<b>${esc(object.nombre)}</b> · NP ${esc(object.np)}` +
        `<br/>Categoría: ${esc(object.categoria)}` +
        `<br/>Valor: ${esc(object.valor)} pallets` +
        `<br/>${esc(object.direccion)}` +
        `<br/>Fecha pedida: ${fechaCorta(object.fecha)}` +
        demora,
      style: estilo,
    };
  };

  const cuenta = (e) => (e === 'Todos' ? pedidos.length : pedidos.filter((p) => p.categoria === e).length);

  return (
    <section aria-label="Mapa de entregas">
      <div className="controles">
        <div className="grupo" role="group" aria-label="Filtrar por estado">
          {['Todos', ...ESTADOS].map((e) => (
            <button key={e} className={estado === e ? 'chip on' : 'chip'} onClick={() => setEstado(e)}>
              {e !== 'Todos' && <span className="punto" style={{ background: hex(e) }} />}
              {e} <span className="ct">{cuenta(e)}</span>
            </button>
          ))}
        </div>
        <div className="grupo" role="group" aria-label="Tipo de visualización">
          {MODOS.map((m) => (
            <button key={m.id} className={modo === m.id ? 'seg on' : 'seg'} onClick={() => setModo(m.id)}>
              {m.label}
            </button>
          ))}
        </div>
      </div>

      <div className="mapa-grid">
        <div className="mapa-caja">
          <DeckGL initialViewState={VISTA_INICIAL} controller={true} layers={layers} getTooltip={tooltip}>
            <Map mapStyle={MAPA_BASE} />
          </DeckGL>
        </div>

        <aside className="panel">
          <p className="ayuda">{AYUDA[modo]}</p>
          <div className="leyenda">
            {ESTADOS.map((e) => (
              <span key={e}>
                <span className="punto" style={{ background: hex(e) }} /> {e}
              </span>
            ))}
            <span>
              <span className="cuadrado" /> Centro logístico
            </span>
          </div>
          <h3>¿Dónde hay más demora?</h3>
          <p className="ayuda">Promedio de horas de demora en las entregas realizadas.</p>
          <ol className="zonas">
            {zonas.map((z) => (
              <li key={z.localidad}>
                <span>{z.localidad}</span>
                <b>{fmt(z.prom, 1)} h</b>
              </li>
            ))}
          </ol>
        </aside>
      </div>
    </section>
  );
}
