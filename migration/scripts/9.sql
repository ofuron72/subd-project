-- 9. Вывести клиентов, у которых за последние 10 дней не было транзакций

select from client c join public.account a on c.client_id = a.client_id
join public.transaction t on a.account_id = t.account_id
