-- 10. клиент у которого самая большая сумма покупок за последний месяц

SELECT c.client_id,
       c.full_name,
       SUM(ABS(t.amount)) AS total_purchases
FROM client c
         JOIN account a
              ON c.client_id = a.client_id
         JOIN public.transaction t
              ON a.account_id = t.account_id
WHERE t.transaction_type = 'Снятие'
  AND t.create_dttm >= now() - interval '5 month'
GROUP BY c.client_id, c.full_name
HAVING SUM(ABS(t.amount)) = (
    SELECT MAX(client_sum)
    FROM (
             SELECT SUM(ABS(t2.amount)) AS client_sum
             FROM account a2
                      JOIN public.transaction t2
                           ON a2.account_id = t2.account_id
             WHERE t2.transaction_type = 'Снятие'
               AND t2.create_dttm >= now() - interval '5 month'
             GROUP BY a2.client_id
         ) as s
);

select * from transaction;