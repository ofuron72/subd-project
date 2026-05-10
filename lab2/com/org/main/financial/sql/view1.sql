create or replace view client_transaction_summary_view as
select

    c.client_id,
    c.full_name,

    count(t.transaction_id) as transaction_count,

    coalesce(sum(
                     case
                         when t.transaction_type in ('Пополнение', 'INTEREST')
                             then t.amount
                         else 0
                         end
             ), 0) as total_income,

    coalesce(sum(
                     case
                         when t.transaction_type = 'Снятие'
                             then t.amount
                         else 0
                         end
             ), 0) as total_expense

from client c

         left join account a
                   on a.client_id = c.client_id

         left join transaction t
                   on t.account_id = a.account_id

group by
    c.client_id,
    c.full_name;

--read only
select * from client_transaction_summary_view;