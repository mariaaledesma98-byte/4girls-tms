import { fechaCorta, fmt, hex } from './util.js';

export function TablaPedidos({ pedidos }) {
  return (
    <div className="tabla-caja">
      <table>
        <thead>
          <tr>
            <th>NP</th>
            <th>Cliente</th>
            <th>Productos</th>
            <th className="num">Pallets</th>
            <th>Entrega</th>
            <th>Fecha pedida</th>
            <th>Camioneta</th>
            <th>Estado</th>
          </tr>
        </thead>
        <tbody>
          {pedidos.map((p) => (
            <tr key={p.np}>
              <td className="fuerte">{p.np}</td>
              <td>{p.nombre}</td>
              <td>{p.descripcion}</td>
              <td className="num fuerte">{p.valor}</td>
              <td>{p.direccion}</td>
              <td>{fechaCorta(p.fecha)}</td>
              <td>{p.camioneta}</td>
              <td>
                <span className="etiqueta" style={{ background: hex(p.categoria) }}>
                  {p.categoria}
                </span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export function TablaArticulos({ productos }) {
  return (
    <div className="tabla-caja">
      <table>
        <thead>
          <tr>
            <th>SKU</th>
            <th>Descripción</th>
            <th className="num">Unid. / bulto</th>
            <th className="num">Bultos / pallet</th>
            <th className="num">Unid. / pallet</th>
            <th className="num">Peso pallet (kg)</th>
          </tr>
        </thead>
        <tbody>
          {productos.map((a) => (
            <tr key={a.sku}>
              <td className="fuerte">{a.sku}</td>
              <td>{a.descripcion}</td>
              <td className="num">{a.unidades_por_bulto}</td>
              <td className="num">{a.bultos_por_pallet}</td>
              <td className="num">{fmt(a.unidades_por_bulto * a.bultos_por_pallet)}</td>
              <td className="num">{fmt(a.peso_pallet_kg)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
