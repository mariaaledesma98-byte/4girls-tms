import { createClient } from '@supabase/supabase-js';

// La dirección y la clave "publishable" de Supabase son públicas por diseño
// (las usa el navegador). La seguridad la dan las políticas RLS de la base.
const url = 'https://hxfzlckhyiqsponulahx.supabase.co';
const key = 'sb_publishable_-NtvReYHl2UmN3aK1jd--Q_5VdZgaum';

export const supabase = createClient(url, key);
