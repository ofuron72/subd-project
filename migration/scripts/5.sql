-- 1. вывести информацию о счете на котором происходит меньше всего операций
select account_id,
       client_id,
       account_number,
       account_type,
       currency_id,
       balance,
       create_dttm,
       modify_dttm
from account as a
where account_id in (select t.account_id
                     from account ac
                              join public.transaction t on ac.account_id = t.account_id
                     group by t.account_id);

select count(*), t.account_id from account ac join public.transaction t on ac.account_id = t.account_id
group by t.account_id


