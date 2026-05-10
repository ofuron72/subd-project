create or replace function update_modify_dttm()
    returns trigger
    language plpgsql
as
$$
begin
    new.modify_dttm = now();

    return new;
end;
$$;


create trigger trg_client_modify_dttm
    before update
    on client
    for each row
execute function update_modify_dttm();

create trigger trg_employee_modify_dttm
    before update
    on employee
    for each row
execute function update_modify_dttm();

create trigger trg_currency_modify_dttm
    before update
    on currency
    for each row
execute function update_modify_dttm();

create trigger trg_account_modify_dttm
    before update
    on account
    for each row
execute function update_modify_dttm();

create trigger trg_transaction_modify_dttm
    before update
    on transaction
    for each row
execute function update_modify_dttm();