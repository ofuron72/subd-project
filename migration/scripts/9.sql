-- 9. Вывести клиентов, у которых за последние 10 дней не было транзакций

select distinct c.client_id,
       c.full_name from client c left join public.account a on c.client_id = a.client_id
left join public.transaction t on a.account_id = t.account_id
    and
        t.create_dttm >= now() - interval '10 day'
where t.transaction_id is null;

select * from client;




