create or replace procedure generate_monthly_report(
    p_from date,
    p_to date
)
    language plpgsql
as
$$
declare

    v_client record;

    v_income decimal(15, 2);

    v_expense decimal(15, 2);

    v_transaction_count bigint;

    client_cursor cursor for
        select client_id
        from client;

begin

    open client_cursor;

    loop

        fetch client_cursor into v_client;

        exit when not found;

        select coalesce(sum(amount), 0)
        into v_income
        from transaction t
                 join account a
                      on a.account_id = t.account_id
        where a.client_id = v_client.client_id
          and t.transaction_type in ('Пополнение', 'INTEREST')
          and t.create_dttm between p_from and p_to;

        select coalesce(sum(amount), 0)
        into v_expense
        from transaction t
                 join account a
                      on a.account_id = t.account_id
        where a.client_id = v_client.client_id
          and t.transaction_type = 'Снятие'
          and t.create_dttm between p_from and p_to;

        select count(*)
        into v_transaction_count
        from transaction t
                 join account a
                      on a.account_id = t.account_id
        where a.client_id = v_client.client_id
          and t.create_dttm between p_from and p_to;

        insert into monthly_client_report(
            client_id,
            period_from,
            period_to,
            total_income,
            total_expense,
            transaction_count,
            generated_at
        )
        values (
                   v_client.client_id,
                   p_from,
                   p_to,
                   v_income,
                   v_expense,
                   v_transaction_count,
                   now()
               );

    end loop;

    close client_cursor;

end;
$$;