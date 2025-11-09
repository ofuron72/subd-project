-- 4) вывести все транзацкии за день, и типу валюты,
--  и выводим транзакции за день по определенному типу валюты

select t.transaction_id as "идентификатор",
       t.amount as "сумма",
       t.transaction_type as "тип транзакции",
       c.code as "валюта",
       t.description as "описание",
       t.create_dttm::date as "день"
from transaction t
         join public.currency c on c.currency_id = t.currency_id
where c.code = 'RUB'
  AND t.create_dttm::date = to_date('09-11-2025', 'DD-MM-YYYY');

select *
from transaction;