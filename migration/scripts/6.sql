-- вывести информацию о клиенте у которого больше всего счетов и информацию об этих счетах

select c.client_id,
       c.full_name,
       c.birth_date,
       c.passport,
       c.phone,
       c.email,
       c.create_dttm,
       c.modify_dttm
from client c where client_id = first_value(client_id) over (select count(*), a.client_id from client c
         join public.account a on c.client_id = a.client_id
group by a.client_id order by count(*) desc );

select a.client_id, count(*) from client c
                            join public.account a on c.client_id = a.client_id
group by a.client_id