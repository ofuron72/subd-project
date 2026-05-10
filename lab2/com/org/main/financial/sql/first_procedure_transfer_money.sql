create or replace procedure transfer_money(
    p_from_account_id bigint,
    p_to_account_id bigint,
    p_amount decimal
)
    language plpgsql
as
$$
declare
    v_from_balance decimal;
begin

    if p_amount <= 0 then
        raise exception 'Amount must be positive';
    end if;

    select balance
    into v_from_balance
    from account
    where account_id = p_from_account_id
        for update;

    if v_from_balance is null then
        raise exception 'Sender account not found';
    end if;

    if v_from_balance < p_amount then
        raise exception 'Insufficient funds';
    end if;

    update account
    set balance = balance - p_amount
    where account_id = p_from_account_id;

    update account
    set balance = balance + p_amount
    where account_id = p_to_account_id;

    insert into transaction(
        account_id,
        currency_id,
        amount,
        transaction_type,
        description
    )
    values
        (
            p_from_account_id,
            (select currency_id from account where account_id = p_from_account_id),
            p_amount,
            'Снятие',
            'Money transfer outgoing'
        ),
        (
            p_to_account_id,
            (select currency_id from account where account_id = p_to_account_id),
            p_amount,
            'Пополнение',
            'Money transfer incoming'
        );

end;
$$;