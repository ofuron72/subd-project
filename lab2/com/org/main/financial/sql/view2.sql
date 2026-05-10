-- updateble
create or replace view client_view as
select
    client_id,
    full_name,
    passport,
    phone,
    email
from client;

update client_view
set phone = '+78005553535'
where client_id = 1;

