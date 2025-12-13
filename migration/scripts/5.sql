-- 1. вывести информацию о счете на котором происходит меньше всего операций
select
    a.account_id as "Идентификатор счета",
    a.account_number as "Номер счета",
    a.account_type as "Тип счета",
    a.balance as "Баланс",
    count(t.transaction_id) as "число транзакций"
from account a
         left join transaction t
                   on t.account_id = a.account_id
group by
    a.account_id,
    a.account_number,
    a.account_type,
    a.balance
order by count(t.transaction_id)
limit 1;

