import { createClient } from '@supabase/supabase-js';

// Estos dos datos se cargan en Vercel (o en el archivo .env si probás en tu computadora).
// Se limpian por si al copiarlos se coló algún espacio o carácter invisible.
const limpiar = (v) => String(v ?? '').replace(/[^\x21-\x7E]/g, '');
const url = limpiar(import.meta.env.VITE_SUPABASE_URL);
const key = limpiar(import.meta.env.VITE_SUPABASE_ANON_KEY);

// Si faltan, la app sigue funcionando con datos de ejemplo y avisa en pantalla.
export const supabase =
  url && key && !url.includes('TU-PROYECTO') ? createClient(url, key) : null;
