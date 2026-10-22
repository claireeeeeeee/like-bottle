-- 给已上线的数据库加「大类」功能：在 Supabase SQL Editor 里运行一次即可（重复运行也没问题）
alter table public.bottles add column if not exists category text not null default '';

create or replace function public.editor_get_bottles(p_code text)
returns jsonb language plpgsql security definer set search_path=public as $$
begin
  if not public.check_editor_code(p_code) then return jsonb_build_object('ok',false); end if;
  return jsonb_build_object('ok',true,'bottles',coalesce((select jsonb_agg(jsonb_build_object('id',id,'name',name,'category',category,'sort_order',sort_order) order by sort_order,id) from public.bottles),'[]'::jsonb));
end;$$;
revoke all on function public.editor_get_bottles(text) from public;
grant execute on function public.editor_get_bottles(text) to anon, authenticated;

drop function if exists public.editor_replace_bottles(text,text[]);
create or replace function public.editor_replace_bottles(p_code text,p_names text[],p_categories text[])
returns jsonb language plpgsql security definer set search_path=public as $$
begin
  if not public.check_editor_code(p_code) then return jsonb_build_object('ok',false); end if;
  if not exists(select 1 from unnest(p_names) x where trim(x)<>'') then raise exception '至少需要一个瓶子'; end if;
  delete from public.bottles;
  insert into public.bottles(name,category,sort_order)
  select trim(n),coalesce(trim(c),''),ord::int from unnest(p_names,p_categories) with ordinality as t(n,c,ord) where trim(n)<>'';
  return jsonb_build_object('ok',true,'bottles',(select jsonb_agg(jsonb_build_object('id',id,'name',name,'category',category,'sort_order',sort_order) order by sort_order,id) from public.bottles));
end;$$;
revoke all on function public.editor_replace_bottles(text,text[],text[]) from public;
grant execute on function public.editor_replace_bottles(text,text[],text[]) to anon, authenticated;
