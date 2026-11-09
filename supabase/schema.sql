-- ============================================================
-- 4 Girls TMS - base de datos de la PoC (Supabase)
-- Pegá TODO este texto en Supabase > SQL Editor y tocá "Run".
-- Crea las tablas, deja la lectura pública y carga los datos de ejemplo.
-- ============================================================

drop table if exists public.pedidos;
drop table if exists public.productos;

-- Maestro de productos (el Excel de María)
create table public.productos (
  sku                text primary key,
  descripcion        text not null,
  categoria          text,
  unidades_por_bulto int,
  bultos_por_pallet  int,
  peso_pallet_kg     numeric,
  alto_pallet_cm     numeric
);

-- Notas de pedido con su ubicación de entrega
-- (nombre = cliente, categoria = estado, valor = pallets, fecha = fecha comprometida)
create table public.pedidos (
  id            bigint generated always as identity primary key,
  np            bigint unique not null,
  nombre        text not null,
  categoria     text not null check (categoria in ('Pendiente','En camino','Entregado','Rechazado')),
  latitud       double precision not null,
  longitud      double precision not null,
  valor         int not null,
  fecha         date not null,
  descripcion   text,
  direccion     text,
  localidad     text,
  camioneta     text,
  demora_horas  numeric
);

-- Seguridad: cualquiera puede LEER (con la clave pública), nadie puede escribir.
alter table public.productos enable row level security;
alter table public.pedidos   enable row level security;
create policy "lectura publica productos" on public.productos for select to anon using (true);
create policy "lectura publica pedidos"   on public.pedidos   for select to anon using (true);

-- Productos
insert into public.productos (sku, descripcion, categoria, unidades_por_bulto, bultos_por_pallet, peso_pallet_kg, alto_pallet_cm) values
('BEB-AGU-NAT-15', 'Botella Agua 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-AGU-MAN-15', 'Botella Agua Saborizada Manzana 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-AGU-NAR-15', 'Botella Agua Saborizada Naranja 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-AGU-POM-15', 'Botella Agua Saborizada Pomelo 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-AGU-ANA-15', 'Botella Agua Saborizada Ananá 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-AGU-PER-15', 'Botella Agua Saborizada Pera 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-AGU-NAT-22', 'Botella Agua 2,25L', 'Bebidas', 6, 45, 651, 123),
('BEB-GAS-COL-22', 'Botella Gaseosa Cola 2,25L', 'Bebidas', 6, 45, 651, 123),
('BEB-GAS-CLI-22', 'Botella Gaseosa Cola Light 2,25L', 'Bebidas', 6, 45, 651, 123),
('BEB-GAS-NAR-22', 'Botella Gaseosa Naranja 2,25L', 'Bebidas', 6, 45, 651, 123),
('BEB-GAS-LIM-22', 'Botella Gaseosa Lima 2,25L', 'Bebidas', 6, 45, 651, 123),
('BEB-GAS-POM-22', 'Botella Gaseosa Pomelo 2,25L', 'Bebidas', 6, 45, 651, 123),
('BEB-GAS-COL-L3', 'Lata Gaseosa Cola 354ml', 'Bebidas', 24, 100, 910, 138),
('BEB-GAS-CLI-L3', 'Lata Gaseosa Cola Light 354ml', 'Bebidas', 24, 100, 910, 138),
('BEB-GAS-NAR-L3', 'Lata Gaseosa Naranja 354ml', 'Bebidas', 24, 100, 910, 138),
('BEB-GAS-LIM-L3', 'Lata Gaseosa Lima 354ml', 'Bebidas', 24, 100, 910, 138),
('BEB-GAS-POM-L3', 'Lata Gaseosa Pomelo 354ml', 'Bebidas', 24, 100, 910, 138),
('BEB-ISO-TRO-15', 'Botella Isotónica Tropical 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-ISO-MAN-15', 'Botella Isotónica Manzana 1,5L', 'Bebidas', 6, 80, 774, 147),
('BEB-ISO-FRO-15', 'Botella Isotónica Frozen 1,5L', 'Bebidas', 6, 80, 774, 147);

-- Pedidos
insert into public.pedidos (np, nombre, categoria, latitud, longitud, valor, fecha, descripcion, direccion, localidad, camioneta, demora_horas) values
(10176901, 'Autoservicio El Faro', 'En camino', -34.55146, -58.4656, 3, '2026-11-02', '2 pallets Botella Gaseosa Cola 2,25L · 1 pallet Botella Gaseosa Naranja 2,25L', 'Ruta 8 1911, Belgrano', 'Belgrano', 'Camioneta 2', null),
(10176902, 'Minimarket Belgrano', 'En camino', -34.58527, -58.54226, 3, '2026-11-03', '1 pallet Lata Gaseosa Naranja 354ml · 1 pallet Lata Gaseosa Cola 354ml · 1 pallet Lata Gaseosa Pomelo 354ml', 'Av. Sarmiento 207, San Martín', 'San Martín', 'Camioneta 2', null),
(10176903, 'Kiosco El Cruce', 'En camino', -34.56926, -58.5391, 4, '2026-11-02', '1 pallet Botella Isotónica Frozen 1,5L · 2 pallets Botella Gaseosa Pomelo 2,25L · 1 pallet Lata Gaseosa Cola 354ml', 'Av. Hipólito Yrigoyen 654, San Martín', 'San Martín', 'Camioneta 2', null),
(10176904, 'Despensa Norte', 'Pendiente', -34.33844, -58.78847, 2, '2026-11-05', '1 pallet Botella Isotónica Frozen 1,5L · 1 pallet Botella Gaseosa Naranja 2,25L', 'Av. Libertador 4006, Escobar', 'Escobar', 'Sin asignar', null),
(10176905, 'Almacén Los Tilos', 'En camino', -34.69973, -58.40043, 1, '2026-11-02', '1 pallet Botella Agua Saborizada Naranja 1,5L', 'Av. Mitre 1437, Lanús', 'Lanús', 'Camioneta 2', null),
(10176906, 'Drugstore Las Heras', 'Pendiente', -34.45674, -58.9113, 3, '2026-11-03', '1 pallet Botella Gaseosa Cola Light 2,25L · 1 pallet Botella Agua 1,5L · 1 pallet Lata Gaseosa Pomelo 354ml', 'Av. Mitre 2692, Pilar', 'Pilar', 'Sin asignar', null),
(10176907, 'Autoservicio La Estrella', 'En camino', -34.463, -58.62981, 3, '2026-11-03', '2 pallets Botella Isotónica Frozen 1,5L · 1 pallet Botella Agua Saborizada Pera 1,5L', 'Av. San Martín 766, General Pacheco', 'General Pacheco', 'Camioneta 1', null),
(10176908, 'Despensa Los Álamos', 'Entregado', -34.64875, -58.61443, 3, '2026-11-02', '1 pallet Botella Agua Saborizada Ananá 1,5L · 1 pallet Lata Gaseosa Pomelo 354ml · 1 pallet Lata Gaseosa Cola Light 354ml', 'Av. San Martín 2197, Morón', 'Morón', 'Camioneta 1', 1.1),
(10176909, 'Distribuidora La Estrella', 'Entregado', -34.6525, -58.62453, 2, '2026-11-01', '1 pallet Botella Gaseosa Lima 2,25L · 1 pallet Botella Agua Saborizada Pera 1,5L', 'Av. Mitre 2382, Morón', 'Morón', 'Camioneta 1', 3.2),
(10176910, 'Autoservicio La Esquina', 'Rechazado', -34.71794, -58.38096, 1, '2026-10-28', '1 pallet Botella Agua Saborizada Naranja 1,5L', 'Calle Lavalle 225, Lanús', 'Lanús', 'Camioneta 2', null),
(10176911, 'Almacén Norte', 'Rechazado', -34.52432, -58.47386, 4, '2026-11-01', '1 pallet Botella Agua Saborizada Pera 1,5L · 1 pallet Lata Gaseosa Naranja 354ml · 2 pallets Lata Gaseosa Cola 354ml', 'Av. Libertador 977, Vicente López', 'Vicente López', 'Camioneta 2', null),
(10176912, 'Minimarket Santa Rita', 'Pendiente', -34.63923, -58.79314, 3, '2026-11-04', '2 pallets Botella Isotónica Frozen 1,5L · 1 pallet Botella Agua Saborizada Manzana 1,5L', 'Calle Italia 2618, Moreno', 'Moreno', 'Sin asignar', null),
(10176913, 'Distribuidora Los Pinos', 'Pendiente', -34.61914, -58.43369, 1, '2026-11-02', '1 pallet Botella Gaseosa Cola 2,25L', 'Av. Independencia 413, Caballito', 'Caballito', 'Sin asignar', null),
(10176914, 'Minimarket Central', 'Entregado', -34.68305, -58.5505, 3, '2026-11-02', '2 pallets Botella Agua Saborizada Naranja 1,5L · 1 pallet Botella Agua Saborizada Pera 1,5L', 'Calle Moreno 2146, San Justo', 'San Justo', 'Camioneta 1', 0.0),
(10176915, 'Kiosco El Mirador', 'Entregado', -34.46398, -58.64983, 4, '2026-10-26', '2 pallets Botella Agua Saborizada Ananá 1,5L · 2 pallets Botella Gaseosa Naranja 2,25L', 'Av. Rivadavia 1952, El Talar', 'El Talar', 'Camioneta 1', 0.0),
(10176916, 'Almacén La Estrella', 'Entregado', -34.68077, -58.57376, 1, '2026-10-28', '1 pallet Botella Agua 1,5L', 'Calle Moreno 2925, San Justo', 'San Justo', 'Camioneta 1', 4.3),
(10176917, 'Drugstore San Jorge', 'Pendiente', -34.66684, -58.36768, 3, '2026-11-08', '1 pallet Lata Gaseosa Cola 354ml · 1 pallet Botella Agua Saborizada Manzana 1,5L · 1 pallet Botella Agua Saborizada Pera 1,5L', 'Av. Hipólito Yrigoyen 4269, Avellaneda', 'Avellaneda', 'Sin asignar', null),
(10176918, 'Kiosco San Martín', 'Rechazado', -34.57422, -58.53117, 2, '2026-10-31', '1 pallet Botella Gaseosa Lima 2,25L · 1 pallet Botella Agua Saborizada Pera 1,5L', 'Av. Sarmiento 2360, San Martín', 'San Martín', 'Camioneta 2', null),
(10176919, 'Mayorista Don Luis', 'Entregado', -34.5337, -58.7007, 2, '2026-10-27', '1 pallet Botella Gaseosa Lima 2,25L · 1 pallet Botella Agua 2,25L', 'Av. Mitre 3401, San Miguel', 'San Miguel', 'Camioneta 1', 3.0),
(10176920, 'Supermercado San Martín', 'Pendiente', -34.58391, -58.52815, 1, '2026-11-02', '1 pallet Botella Isotónica Frozen 1,5L', 'Av. Corrientes 1459, San Martín', 'San Martín', 'Sin asignar', null),
(10176921, 'Supermercado Mitre', 'Entregado', -34.67888, -58.55177, 3, '2026-10-31', '1 pallet Botella Agua 2,25L · 2 pallets Lata Gaseosa Lima 354ml', 'Av. Libertador 1463, San Justo', 'San Justo', 'Camioneta 1', 6.8),
(10176922, 'Supermercado El Trébol', 'Entregado', -34.45704, -58.64861, 4, '2026-10-28', '2 pallets Botella Gaseosa Naranja 2,25L · 2 pallets Botella Isotónica Manzana 1,5L', 'Calle Moreno 720, General Pacheco', 'General Pacheco', 'Camioneta 1', 0.3),
(10176923, 'Almacén El Parque', 'En camino', -34.65385, -58.71852, 2, '2026-11-02', '2 pallets Botella Agua Saborizada Pera 1,5L', 'Calle 25 de Mayo 385, Merlo', 'Merlo', 'Camioneta 1', null),
(10176924, 'Autoservicio Las Heras', 'Entregado', -34.63995, -58.55894, 3, '2026-10-28', '1 pallet Botella Gaseosa Pomelo 2,25L · 1 pallet Botella Agua Saborizada Pera 1,5L · 1 pallet Botella Isotónica Manzana 1,5L', 'Av. Mitre 2245, Ramos Mejía', 'Ramos Mejía', 'Camioneta 1', 0.9),
(10176925, 'Supermercado Del Oeste', 'Entregado', -34.57437, -58.41757, 1, '2026-11-01', '1 pallet Botella Agua 2,25L', 'Ruta 8 4574, Palermo', 'Palermo', 'Camioneta 2', 0.0),
(10176926, 'Kiosco La Proveeduría', 'Pendiente', -34.65313, -58.79138, 2, '2026-11-04', '1 pallet Botella Agua Saborizada Manzana 1,5L · 1 pallet Botella Isotónica Frozen 1,5L', 'Av. Libertador 2530, Moreno', 'Moreno', 'Sin asignar', null),
(10176927, 'Distribuidora Belgrano', 'En camino', -34.52383, -58.48063, 4, '2026-11-02', '2 pallets Botella Gaseosa Pomelo 2,25L · 2 pallets Lata Gaseosa Cola 354ml', 'Av. Libertador 1661, Vicente López', 'Vicente López', 'Camioneta 2', null),
(10176928, 'Mayorista San Jorge', 'Pendiente', -34.72816, -58.25377, 1, '2026-11-03', '1 pallet Botella Agua 1,5L', 'Calle 25 de Mayo 2734, Quilmes', 'Quilmes', 'Sin asignar', null),
(10176929, 'Kiosco El Faro', 'Pendiente', -34.76066, -58.41671, 2, '2026-11-06', '1 pallet Lata Gaseosa Cola 354ml · 1 pallet Botella Agua Saborizada Pera 1,5L', 'Ruta 8 2972, Lomas de Zamora', 'Lomas de Zamora', 'Sin asignar', null),
(10176930, 'Minimarket Las Heras', 'Entregado', -34.54479, -58.72023, 1, '2026-10-27', '1 pallet Lata Gaseosa Cola Light 354ml', 'Av. Mitre 742, San Miguel', 'San Miguel', 'Camioneta 1', 0.3),
(10176931, 'Almacén Belgrano', 'Entregado', -34.63753, -58.78905, 1, '2026-10-31', '1 pallet Botella Isotónica Frozen 1,5L', 'Calle Italia 260, Moreno', 'Moreno', 'Camioneta 1', 6.3),
(10176932, 'Distribuidora Los Álamos', 'Entregado', -34.58985, -58.42731, 4, '2026-10-29', '1 pallet Botella Agua Saborizada Ananá 1,5L · 2 pallets Botella Agua Saborizada Manzana 1,5L · 1 pallet Botella Isotónica Frozen 1,5L', 'Av. Independencia 3146, Palermo', 'Palermo', 'Camioneta 2', 2.1),
(10176933, 'Autoservicio La Colonia', 'Entregado', -34.47451, -58.52438, 4, '2026-10-26', '2 pallets Botella Isotónica Manzana 1,5L · 1 pallet Botella Gaseosa Pomelo 2,25L · 1 pallet Botella Gaseosa Cola Light 2,25L', 'Av. Hipólito Yrigoyen 1346, San Isidro', 'San Isidro', 'Camioneta 2', 2.5),
(10176934, 'Minimarket Los Álamos', 'Entregado', -34.5348, -58.71877, 4, '2026-10-29', '2 pallets Botella Agua Saborizada Pomelo 1,5L · 2 pallets Botella Agua Saborizada Naranja 1,5L', 'Calle Moreno 1245, San Miguel', 'San Miguel', 'Camioneta 1', 2.8),
(10176935, 'Distribuidora La Perla', 'Entregado', -34.65387, -58.55692, 2, '2026-10-28', '2 pallets Botella Agua Saborizada Manzana 1,5L', 'Av. Hipólito Yrigoyen 1541, Ramos Mejía', 'Ramos Mejía', 'Camioneta 1', 3.5),
(10176936, 'Autoservicio Don Carlos', 'Pendiente', -34.58943, -58.53869, 3, '2026-11-07', '1 pallet Botella Agua 2,25L · 2 pallets Lata Gaseosa Lima 354ml', 'Av. Corrientes 611, San Martín', 'San Martín', 'Sin asignar', null),
(10176937, 'Autoservicio El Puente', 'En camino', -34.71149, -58.39399, 2, '2026-11-03', '2 pallets Botella Gaseosa Pomelo 2,25L', 'Av. Rivadavia 1740, Lanús', 'Lanús', 'Camioneta 2', null),
(10176938, 'Minimarket Del Sur', 'Entregado', -34.35968, -58.79341, 1, '2026-10-29', '1 pallet Botella Gaseosa Naranja 2,25L', 'Calle Moreno 761, Escobar', 'Escobar', 'Camioneta 1', 3.5),
(10176939, 'Minimarket El Sol', 'Rechazado', -34.73235, -58.26651, 3, '2026-10-28', '2 pallets Lata Gaseosa Pomelo 354ml · 1 pallet Botella Isotónica Frozen 1,5L', 'Av. Rivadavia 4386, Quilmes', 'Quilmes', 'Camioneta 2', null),
(10176940, 'Despensa Del Centro', 'Entregado', -34.67967, -58.55907, 3, '2026-10-28', '1 pallet Botella Isotónica Tropical 1,5L · 1 pallet Botella Agua Saborizada Manzana 1,5L · 1 pallet Botella Isotónica Manzana 1,5L', 'Av. Rivadavia 4336, San Justo', 'San Justo', 'Camioneta 1', 2.6);

-- Verificación: debería mostrar 40 pedidos y 20 productos
select (select count(*) from public.pedidos) as pedidos, (select count(*) from public.productos) as productos;
