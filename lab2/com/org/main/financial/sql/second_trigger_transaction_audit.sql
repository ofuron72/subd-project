create or replace function audit_transaction()
    returns trigger
    language plpgsql
as
$$
begin
    insert into transaction_audit(
        transaction_id,
        amount,
        transaction_type,
        created_dttm
    )
    values (
               new.transaction_id,
               new.amount,
               new.transaction_type,
               now()
           );

    return new;
end;
$$;

create trigger trg_transaction_audit
    after insert
    on transaction
    for each row
execute function audit_transaction();