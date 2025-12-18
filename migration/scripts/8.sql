-- 8. Получить список клиентов, у которых за последние 6 месяцев был минимум один крупный платеж (больше 100 000),
--  и их средний баланс по счетам за этот период превышает 200 000.

select c.client_id, c.full_name, max(t.amount), avg(t.amount), max(t.amount) from client c
    join public.account a on c.client_id = a.client_id
    join public.transaction t on a.account_id = t.account_id
       where t.create_dttm >= now() - interval '6 month'
group by c.client_id, c.full_name
    having max(t.amount) >10000
    and avg(t.amount) > 5000