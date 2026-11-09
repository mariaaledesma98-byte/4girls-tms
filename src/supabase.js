import { createClient } from '@supabase/supabase-js';

// Estos dos datos se cargan en Vercel (o en el archivo .env si probás en tu computadora).
const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Si faltan, la app sigue funcionando con datos de ejemplo y avisa en pantalla.
export const supabase =
  url && key && !url.includes('TU-PROYECTO') ? createClient(url, key) : null;
