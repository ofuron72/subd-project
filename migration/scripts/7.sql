-- 7. Для каждого клиента определить сумму всех транзакций за последний месяц, разделённую по типам транзакций,
--  и вывести клиентов, у которых сумма превышает 50 000.

select sum(t.amount), t.transaction_type, c.client_id,c.full_name from transaction t
    join public.account a on a.account_id = t.account_id
    join public.client c on c.client_id = a.client_id
                                         where t.create_dttm >= now() - interval '2 month'
group by t.transaction_type, c.client_id having sum(t.amount) > 5000;
