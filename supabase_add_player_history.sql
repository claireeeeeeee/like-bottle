-- 玩家用同样的名字进入时，读取这个名字最近一次的提交：在 Supabase SQL Editor 里运行一次即可（重复运行也没问题）
create or replace function public.player_get_latest_submission(p_name text)
returns jsonb language sql security definer set search_path=public as $$
  select jsonb_build_object('ok',true,'submission',
    (select jsonb_build_object('id',id,'player_name',player_name,'answers',answers,'created_at',created_at)
     from public.submissions where player_name=trim(p_name) order by created_at desc limit 1));
$$;
revoke all on function public.player_get_latest_submission(text) from public;
grant execute on function public.player_get_latest_submission(text) to anon, authenticated;
