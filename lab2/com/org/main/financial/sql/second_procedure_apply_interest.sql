create or replace procedure apply_interest()
    language plpgsql
as
$$
declare

    v_account record;

    v_interest decimal(15, 2);

    account_cursor cursor for
        select account_id,
               balance,
               currency_id
        from account
        where account_type = 'Валютный';

begin

    open account_cursor;

    loop

        fetch account_cursor into v_account;

        exit when not found;

        v_interest := v_account.balance * 0.05;

        update account
        set balance = balance + v_interest
        where account_id = v_account.account_id;

        insert into transaction(
            account_id,
            currency_id,
            amount,
            transaction_type,
            description
        )
        values (
                   v_account.account_id,
                   v_account.currency_id,
                   v_interest,
                   'INTEREST',
                   'Начисление процентов'
               );

    end loop;

    close account_cursor;

end;
$$;