-- 5. вывести информацию о счете на котором происходит меньше всего операций
with account_count_transactions as (
    select a.account_id as "Идентификатор счета",
    a.account_number as "Номер счета",
    a.account_type as "Тип счета",
    a.balance as "Баланс",
        count(t.transaction_id) as count_transaction
    from account a
    left join transaction t
        on t.account_id = a.account_id
    group by
        a.account_id
)
select * from account_count_transactions
         where count_transaction = (select min(count_transaction)
                                    from account_count_transactions
                                    )


