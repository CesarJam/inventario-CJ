drop extension if exists "pg_net";


  create table "public"."archivos_anexos" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "id_expediente" uuid not null,
    "nombre_archivo" text not null,
    "tipo_mime" text not null,
    "tamano_bytes" bigint not null,
    "ruta_supabase" text not null,
    "id_usuario_subida" uuid,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."archivos_anexos" enable row level security;


  create table "public"."bitacora_movimientos" (
    "id" uuid not null default gen_random_uuid(),
    "id_expediente" uuid,
    "id_usuario" uuid,
    "accion" text not null,
    "detalles" jsonb,
    "fecha_hora" timestamp with time zone default now()
      );


alter table "public"."bitacora_movimientos" enable row level security;


  create table "public"."cuadro_general" (
    "id" uuid not null default gen_random_uuid(),
    "codigo" text not null,
    "seccion" text not null,
    "funcion" text default 'Sustantivas'::text
      );


alter table "public"."cuadro_general" enable row level security;


  create table "public"."dependencias" (
    "id" uuid not null default gen_random_uuid(),
    "nombre_oficial" text not null,
    "siglas" text,
    "titular" text,
    "tipo_ente" text default 'Estatal'::text,
    "activo" boolean default true
      );


alter table "public"."dependencias" enable row level security;


  create table "public"."expedientes" (
    "id" uuid not null default gen_random_uuid(),
    "numero_consecutivo" text not null,
    "asunto" text not null,
    "dependencias_ids" uuid[],
    "fojas" integer default 1,
    "caracter" text,
    "fecha_registro" date not null default CURRENT_DATE,
    "hora_registro" time without time zone not null default CURRENT_TIME,
    "id_seccion_registro" uuid,
    "id_seccion_turnada" uuid,
    "estatus" text default 'Recepcionado'::text,
    "observaciones" text,
    "id_usuario_registro" uuid,
    "id_usuario_actualizacion" uuid,
    "soporte" text,
    "tradicion" text,
    "condicion_acceso" text,
    "inmueble" text,
    "ubicacion_url" text,
    "id_serie" uuid,
    "codigo_subserie" text,
    "responsable_tramite" text,
    "indicaciones_tramite" text,
    "snapshot_cadido" jsonb
      );


alter table "public"."expedientes" enable row level security;


  create table "public"."series" (
    "id" uuid not null default gen_random_uuid(),
    "codigo_serie" text not null,
    "nombre" text not null,
    "id_seccion" uuid,
    "subseries" jsonb default '[]'::jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."series" enable row level security;


  create table "public"."usuarios" (
    "id" uuid not null default gen_random_uuid(),
    "email" text not null,
    "nombre" text,
    "rol" text default 'cliente'::text,
    "fecha_creacion" timestamp with time zone not null default timezone('utc'::text, now()),
    "secciones_permitidas" text[] default '{}'::text[]
      );


alter table "public"."usuarios" enable row level security;

CREATE UNIQUE INDEX archivos_anexos_pkey ON public.archivos_anexos USING btree (id);

CREATE UNIQUE INDEX bitacora_movimientos_pkey ON public.bitacora_movimientos USING btree (id);

CREATE UNIQUE INDEX cuadro_general_codigo_key ON public.cuadro_general USING btree (codigo);

CREATE UNIQUE INDEX cuadro_general_pkey ON public.cuadro_general USING btree (id);

CREATE UNIQUE INDEX dependencias_nombre_oficial_key ON public.dependencias USING btree (nombre_oficial);

CREATE UNIQUE INDEX dependencias_pkey ON public.dependencias USING btree (id);

CREATE UNIQUE INDEX expedientes_pkey ON public.expedientes USING btree (id);

CREATE INDEX idx_archivos_expediente ON public.archivos_anexos USING btree (id_expediente);

CREATE UNIQUE INDEX series_codigo_serie_key ON public.series USING btree (codigo_serie);

CREATE UNIQUE INDEX series_pkey ON public.series USING btree (id);

CREATE UNIQUE INDEX unique_folio_por_area ON public.expedientes USING btree (numero_consecutivo, id_seccion_turnada);

CREATE UNIQUE INDEX usuarios_email_key ON public.usuarios USING btree (email);

CREATE UNIQUE INDEX usuarios_pkey ON public.usuarios USING btree (id);

alter table "public"."archivos_anexos" add constraint "archivos_anexos_pkey" PRIMARY KEY using index "archivos_anexos_pkey";

alter table "public"."bitacora_movimientos" add constraint "bitacora_movimientos_pkey" PRIMARY KEY using index "bitacora_movimientos_pkey";

alter table "public"."cuadro_general" add constraint "cuadro_general_pkey" PRIMARY KEY using index "cuadro_general_pkey";

alter table "public"."dependencias" add constraint "dependencias_pkey" PRIMARY KEY using index "dependencias_pkey";

alter table "public"."expedientes" add constraint "expedientes_pkey" PRIMARY KEY using index "expedientes_pkey";

alter table "public"."series" add constraint "series_pkey" PRIMARY KEY using index "series_pkey";

alter table "public"."usuarios" add constraint "usuarios_pkey" PRIMARY KEY using index "usuarios_pkey";

alter table "public"."archivos_anexos" add constraint "archivos_anexos_id_expediente_fkey" FOREIGN KEY (id_expediente) REFERENCES public.expedientes(id) ON DELETE CASCADE not valid;

alter table "public"."archivos_anexos" validate constraint "archivos_anexos_id_expediente_fkey";

alter table "public"."archivos_anexos" add constraint "archivos_anexos_id_usuario_subida_fkey" FOREIGN KEY (id_usuario_subida) REFERENCES auth.users(id) not valid;

alter table "public"."archivos_anexos" validate constraint "archivos_anexos_id_usuario_subida_fkey";

alter table "public"."bitacora_movimientos" add constraint "bitacora_movimientos_id_expediente_fkey" FOREIGN KEY (id_expediente) REFERENCES public.expedientes(id) ON DELETE CASCADE not valid;

alter table "public"."bitacora_movimientos" validate constraint "bitacora_movimientos_id_expediente_fkey";

alter table "public"."bitacora_movimientos" add constraint "bitacora_movimientos_id_usuario_fkey" FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id) ON DELETE SET NULL not valid;

alter table "public"."bitacora_movimientos" validate constraint "bitacora_movimientos_id_usuario_fkey";

alter table "public"."cuadro_general" add constraint "cuadro_general_codigo_key" UNIQUE using index "cuadro_general_codigo_key";

alter table "public"."dependencias" add constraint "dependencias_nombre_oficial_key" UNIQUE using index "dependencias_nombre_oficial_key";

alter table "public"."expedientes" add constraint "expedientes_id_seccion_registro_fkey" FOREIGN KEY (id_seccion_registro) REFERENCES public.cuadro_general(id) ON DELETE SET NULL not valid;

alter table "public"."expedientes" validate constraint "expedientes_id_seccion_registro_fkey";

alter table "public"."expedientes" add constraint "expedientes_id_seccion_turnada_fkey" FOREIGN KEY (id_seccion_turnada) REFERENCES public.cuadro_general(id) ON DELETE SET NULL not valid;

alter table "public"."expedientes" validate constraint "expedientes_id_seccion_turnada_fkey";

alter table "public"."expedientes" add constraint "expedientes_id_serie_fkey" FOREIGN KEY (id_serie) REFERENCES public.series(id) ON DELETE SET NULL not valid;

alter table "public"."expedientes" validate constraint "expedientes_id_serie_fkey";

alter table "public"."expedientes" add constraint "expedientes_id_usuario_actualizacion_fkey" FOREIGN KEY (id_usuario_actualizacion) REFERENCES public.usuarios(id) ON DELETE SET NULL not valid;

alter table "public"."expedientes" validate constraint "expedientes_id_usuario_actualizacion_fkey";

alter table "public"."expedientes" add constraint "expedientes_id_usuario_registro_fkey" FOREIGN KEY (id_usuario_registro) REFERENCES public.usuarios(id) ON DELETE SET NULL not valid;

alter table "public"."expedientes" validate constraint "expedientes_id_usuario_registro_fkey";

alter table "public"."expedientes" add constraint "unique_folio_por_area" UNIQUE using index "unique_folio_por_area";

alter table "public"."series" add constraint "series_codigo_serie_key" UNIQUE using index "series_codigo_serie_key";

alter table "public"."series" add constraint "series_id_seccion_fkey" FOREIGN KEY (id_seccion) REFERENCES public.cuadro_general(id) ON DELETE CASCADE not valid;

alter table "public"."series" validate constraint "series_id_seccion_fkey";

alter table "public"."usuarios" add constraint "usuarios_email_key" UNIQUE using index "usuarios_email_key";

alter table "public"."usuarios" add constraint "usuarios_rol_check" CHECK ((rol = ANY (ARRAY['admin'::text, 'cliente'::text]))) not valid;

alter table "public"."usuarios" validate constraint "usuarios_rol_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_admin()
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.usuarios
    WHERE email = auth.jwt() ->> 'email' AND rol = 'admin'
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_movimiento_expediente()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_accion TEXT;
    v_detalles JSONB;
    v_id_usuario UUID;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        v_accion := 'CREACIÓN';
        v_detalles := jsonb_build_object(
            'estatus_inicial', NEW.estatus,
            'tradicion', NEW.tradicion
        );
        v_id_usuario := NEW.id_usuario_registro;
        
    ELSIF (TG_OP = 'UPDATE') THEN
        IF (OLD.estatus IS DISTINCT FROM NEW.estatus OR OLD.codigo_subserie IS DISTINCT FROM NEW.codigo_subserie) THEN
            IF (OLD.estatus IS DISTINCT FROM NEW.estatus AND NEW.estatus = 'Concluido') THEN
                v_accion := 'CLASIFICACIÓN_CADIDO';
            ELSE
                v_accion := 'CAMBIO_ESTATUS';
            END IF;

            v_detalles := jsonb_build_object(
                'estatus_anterior', OLD.estatus,
                'estatus_nuevo', NEW.estatus,
                'subserie_anterior', OLD.codigo_subserie,
                'subserie_nueva', NEW.codigo_subserie
            );
            v_id_usuario := NEW.id_usuario_actualizacion;
        ELSE
            RETURN NEW;
        END IF;
    END IF;

    INSERT INTO bitacora_movimientos (id_expediente, id_usuario, accion, detalles)
    VALUES (NEW.id, v_id_usuario, v_accion, v_detalles);

    RETURN NEW;
END;
$function$
;

grant delete on table "public"."archivos_anexos" to "anon";

grant insert on table "public"."archivos_anexos" to "anon";

grant references on table "public"."archivos_anexos" to "anon";

grant select on table "public"."archivos_anexos" to "anon";

grant trigger on table "public"."archivos_anexos" to "anon";

grant truncate on table "public"."archivos_anexos" to "anon";

grant update on table "public"."archivos_anexos" to "anon";

grant delete on table "public"."archivos_anexos" to "authenticated";

grant insert on table "public"."archivos_anexos" to "authenticated";

grant references on table "public"."archivos_anexos" to "authenticated";

grant select on table "public"."archivos_anexos" to "authenticated";

grant trigger on table "public"."archivos_anexos" to "authenticated";

grant truncate on table "public"."archivos_anexos" to "authenticated";

grant update on table "public"."archivos_anexos" to "authenticated";

grant delete on table "public"."archivos_anexos" to "service_role";

grant insert on table "public"."archivos_anexos" to "service_role";

grant references on table "public"."archivos_anexos" to "service_role";

grant select on table "public"."archivos_anexos" to "service_role";

grant trigger on table "public"."archivos_anexos" to "service_role";

grant truncate on table "public"."archivos_anexos" to "service_role";

grant update on table "public"."archivos_anexos" to "service_role";

grant delete on table "public"."bitacora_movimientos" to "anon";

grant insert on table "public"."bitacora_movimientos" to "anon";

grant references on table "public"."bitacora_movimientos" to "anon";

grant select on table "public"."bitacora_movimientos" to "anon";

grant trigger on table "public"."bitacora_movimientos" to "anon";

grant truncate on table "public"."bitacora_movimientos" to "anon";

grant update on table "public"."bitacora_movimientos" to "anon";

grant delete on table "public"."bitacora_movimientos" to "authenticated";

grant insert on table "public"."bitacora_movimientos" to "authenticated";

grant references on table "public"."bitacora_movimientos" to "authenticated";

grant select on table "public"."bitacora_movimientos" to "authenticated";

grant trigger on table "public"."bitacora_movimientos" to "authenticated";

grant truncate on table "public"."bitacora_movimientos" to "authenticated";

grant update on table "public"."bitacora_movimientos" to "authenticated";

grant delete on table "public"."bitacora_movimientos" to "service_role";

grant insert on table "public"."bitacora_movimientos" to "service_role";

grant references on table "public"."bitacora_movimientos" to "service_role";

grant select on table "public"."bitacora_movimientos" to "service_role";

grant trigger on table "public"."bitacora_movimientos" to "service_role";

grant truncate on table "public"."bitacora_movimientos" to "service_role";

grant update on table "public"."bitacora_movimientos" to "service_role";

grant delete on table "public"."cuadro_general" to "anon";

grant insert on table "public"."cuadro_general" to "anon";

grant references on table "public"."cuadro_general" to "anon";

grant select on table "public"."cuadro_general" to "anon";

grant trigger on table "public"."cuadro_general" to "anon";

grant truncate on table "public"."cuadro_general" to "anon";

grant update on table "public"."cuadro_general" to "anon";

grant delete on table "public"."cuadro_general" to "authenticated";

grant insert on table "public"."cuadro_general" to "authenticated";

grant references on table "public"."cuadro_general" to "authenticated";

grant select on table "public"."cuadro_general" to "authenticated";

grant trigger on table "public"."cuadro_general" to "authenticated";

grant truncate on table "public"."cuadro_general" to "authenticated";

grant update on table "public"."cuadro_general" to "authenticated";

grant delete on table "public"."cuadro_general" to "service_role";

grant insert on table "public"."cuadro_general" to "service_role";

grant references on table "public"."cuadro_general" to "service_role";

grant select on table "public"."cuadro_general" to "service_role";

grant trigger on table "public"."cuadro_general" to "service_role";

grant truncate on table "public"."cuadro_general" to "service_role";

grant update on table "public"."cuadro_general" to "service_role";

grant delete on table "public"."dependencias" to "anon";

grant insert on table "public"."dependencias" to "anon";

grant references on table "public"."dependencias" to "anon";

grant select on table "public"."dependencias" to "anon";

grant trigger on table "public"."dependencias" to "anon";

grant truncate on table "public"."dependencias" to "anon";

grant update on table "public"."dependencias" to "anon";

grant delete on table "public"."dependencias" to "authenticated";

grant insert on table "public"."dependencias" to "authenticated";

grant references on table "public"."dependencias" to "authenticated";

grant select on table "public"."dependencias" to "authenticated";

grant trigger on table "public"."dependencias" to "authenticated";

grant truncate on table "public"."dependencias" to "authenticated";

grant update on table "public"."dependencias" to "authenticated";

grant delete on table "public"."dependencias" to "service_role";

grant insert on table "public"."dependencias" to "service_role";

grant references on table "public"."dependencias" to "service_role";

grant select on table "public"."dependencias" to "service_role";

grant trigger on table "public"."dependencias" to "service_role";

grant truncate on table "public"."dependencias" to "service_role";

grant update on table "public"."dependencias" to "service_role";

grant delete on table "public"."expedientes" to "anon";

grant insert on table "public"."expedientes" to "anon";

grant references on table "public"."expedientes" to "anon";

grant select on table "public"."expedientes" to "anon";

grant trigger on table "public"."expedientes" to "anon";

grant truncate on table "public"."expedientes" to "anon";

grant update on table "public"."expedientes" to "anon";

grant delete on table "public"."expedientes" to "authenticated";

grant insert on table "public"."expedientes" to "authenticated";

grant references on table "public"."expedientes" to "authenticated";

grant select on table "public"."expedientes" to "authenticated";

grant trigger on table "public"."expedientes" to "authenticated";

grant truncate on table "public"."expedientes" to "authenticated";

grant update on table "public"."expedientes" to "authenticated";

grant delete on table "public"."expedientes" to "service_role";

grant insert on table "public"."expedientes" to "service_role";

grant references on table "public"."expedientes" to "service_role";

grant select on table "public"."expedientes" to "service_role";

grant trigger on table "public"."expedientes" to "service_role";

grant truncate on table "public"."expedientes" to "service_role";

grant update on table "public"."expedientes" to "service_role";

grant delete on table "public"."series" to "anon";

grant insert on table "public"."series" to "anon";

grant references on table "public"."series" to "anon";

grant select on table "public"."series" to "anon";

grant trigger on table "public"."series" to "anon";

grant truncate on table "public"."series" to "anon";

grant update on table "public"."series" to "anon";

grant delete on table "public"."series" to "authenticated";

grant insert on table "public"."series" to "authenticated";

grant references on table "public"."series" to "authenticated";

grant select on table "public"."series" to "authenticated";

grant trigger on table "public"."series" to "authenticated";

grant truncate on table "public"."series" to "authenticated";

grant update on table "public"."series" to "authenticated";

grant delete on table "public"."series" to "service_role";

grant insert on table "public"."series" to "service_role";

grant references on table "public"."series" to "service_role";

grant select on table "public"."series" to "service_role";

grant trigger on table "public"."series" to "service_role";

grant truncate on table "public"."series" to "service_role";

grant update on table "public"."series" to "service_role";

grant delete on table "public"."usuarios" to "anon";

grant insert on table "public"."usuarios" to "anon";

grant references on table "public"."usuarios" to "anon";

grant select on table "public"."usuarios" to "anon";

grant trigger on table "public"."usuarios" to "anon";

grant truncate on table "public"."usuarios" to "anon";

grant update on table "public"."usuarios" to "anon";

grant delete on table "public"."usuarios" to "authenticated";

grant insert on table "public"."usuarios" to "authenticated";

grant references on table "public"."usuarios" to "authenticated";

grant select on table "public"."usuarios" to "authenticated";

grant trigger on table "public"."usuarios" to "authenticated";

grant truncate on table "public"."usuarios" to "authenticated";

grant update on table "public"."usuarios" to "authenticated";

grant delete on table "public"."usuarios" to "service_role";

grant insert on table "public"."usuarios" to "service_role";

grant references on table "public"."usuarios" to "service_role";

grant select on table "public"."usuarios" to "service_role";

grant trigger on table "public"."usuarios" to "service_role";

grant truncate on table "public"."usuarios" to "service_role";

grant update on table "public"."usuarios" to "service_role";


  create policy "Permitir borrado a dueños"
  on "public"."archivos_anexos"
  as permissive
  for delete
  to authenticated
using ((auth.uid() = id_usuario_subida));



  create policy "Permitir inserción a usuarios autenticados"
  on "public"."archivos_anexos"
  as permissive
  for insert
  to authenticated
with check (true);



  create policy "Permitir lectura de anexos a usuarios autenticados"
  on "public"."archivos_anexos"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Bloqueo de borrado en bitácora"
  on "public"."bitacora_movimientos"
  as permissive
  for delete
  to authenticated
using (false);



  create policy "Bloqueo de modificaciones en bitácora"
  on "public"."bitacora_movimientos"
  as permissive
  for update
  to authenticated
using (false);



  create policy "Lectura general de bitácora"
  on "public"."bitacora_movimientos"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Admin Cuadro General ALL"
  on "public"."cuadro_general"
  as permissive
  for all
  to authenticated
using (public.is_admin());



  create policy "Lectura pública para usuarios autenticados"
  on "public"."cuadro_general"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Permitir inserción de dependencias a usuarios autenticados"
  on "public"."dependencias"
  as permissive
  for insert
  to authenticated
with check (true);



  create policy "Permitir lectura de dependencias a usuarios autenticados"
  on "public"."dependencias"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Solo administradores pueden modificar/borrar dependencias"
  on "public"."dependencias"
  as permissive
  for all
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.usuarios
  WHERE ((usuarios.email = (auth.jwt() ->> 'email'::text)) AND (usuarios.rol = 'admin'::text)))));



  create policy "Inserción de expedientes permitida"
  on "public"."expedientes"
  as permissive
  for insert
  to authenticated
with check (true);



  create policy "Lectura de expedientes permitida en la institución"
  on "public"."expedientes"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Solo dueños, admins, o creadores (si no se ha trabajado) puede"
  on "public"."expedientes"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.usuarios
     JOIN public.cuadro_general ON ((cuadro_general.codigo = ANY (usuarios.secciones_permitidas))))
  WHERE ((usuarios.email = (auth.jwt() ->> 'email'::text)) AND ((usuarios.rol = 'admin'::text) OR (cuadro_general.id = expedientes.id_seccion_turnada) OR ((cuadro_general.id = expedientes.id_seccion_registro) AND (expedientes.estatus = 'Recepcionado'::text)))))));



  create policy "Filtrado por secciones permitidas"
  on "public"."series"
  as permissive
  for select
  to authenticated
using (((id_seccion IN ( SELECT cuadro_general.id
   FROM public.cuadro_general
  WHERE (cuadro_general.codigo IN ( SELECT unnest(usuarios.secciones_permitidas) AS unnest
           FROM public.usuarios
          WHERE (usuarios.email = (auth.jwt() ->> 'email'::text)))))) OR (( SELECT usuarios.rol
   FROM public.usuarios
  WHERE (usuarios.email = (auth.jwt() ->> 'email'::text))) = 'admin'::text)));



  create policy "Gestion descentralizada por seccion"
  on "public"."series"
  as permissive
  for all
  to authenticated
using (((id_seccion IN ( SELECT cuadro_general.id
   FROM public.cuadro_general
  WHERE (cuadro_general.codigo IN ( SELECT unnest(usuarios.secciones_permitidas) AS unnest
           FROM public.usuarios
          WHERE (usuarios.email = (auth.jwt() ->> 'email'::text)))))) OR (( SELECT usuarios.rol
   FROM public.usuarios
  WHERE (usuarios.email = (auth.jwt() ->> 'email'::text))) = 'admin'::text)));



  create policy "Acceso total para administradores"
  on "public"."usuarios"
  as permissive
  for all
  to authenticated
using (public.is_admin());



  create policy "Lectura propia"
  on "public"."usuarios"
  as permissive
  for select
  to authenticated
using (((auth.jwt() ->> 'email'::text) = email));


CREATE TRIGGER trigger_auditoria_expedientes AFTER INSERT OR UPDATE ON public.expedientes FOR EACH ROW EXECUTE FUNCTION public.log_movimiento_expediente();


  create policy "Permisos Totales Autenticados yrmky4_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using (((bucket_id = 'expedientes'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Permisos Totales Autenticados yrmky4_1"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'expedientes'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Permisos Totales Autenticados yrmky4_2"
  on "storage"."objects"
  as permissive
  for update
  to public
using (((bucket_id = 'expedientes'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Permisos Totales Autenticados yrmky4_3"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'expedientes'::text) AND (auth.role() = 'authenticated'::text)));



