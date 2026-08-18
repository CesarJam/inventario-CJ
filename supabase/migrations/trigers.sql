-- 1. Creamos la función que se encargará de copiar los datos
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.usuarios (id, email, nombre, rol)
  values (
    new.id, -- El UUID generado en auth.users
    new.email, -- El correo electrónico del usuario
    new.raw_user_meta_data->>'display_name', -- <-- CORRECCIÓN: Extraemos el display_name
    'cliente' -- Asignamos el rol por defecto (puedes cambiarlo a 'user' si prefieres)
  );
  return new;
end;
$$;

-- 2. Nos aseguramos de borrar el anterior si existe y creamos el nuevo
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();