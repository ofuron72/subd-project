-- 6. вывести информацию о клиенте у которого больше всего счетов и информацию об этих счетах

with client_max_accounts as (
    select
        c.client_id,
        c.full_name,
        count(a.account_id) as account_count
    from client c
             join account a
                  on a.client_id = c.client_id
    group by c.client_id, c.full_name
    order by account_count desc
)
select
    c.client_id as "Идентификатор клиента",
    c.full_name as "Полное имя",
    a.account_id as "Идентификатор счета" ,
    a.account_number as "номер счета",
    a.account_type as "Тип счета",
    a.balance as "Баланс"
from client_max_accounts c
         join account a
              on a.client_id = c.client_id
where c.account_count = (select max(account_count) from client_max_accounts);