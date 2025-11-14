-- 1)отсортировать клиентов по дню рождения,

select c.client_id as "идентификатор клиента",
       full_name   as "ФИО",
       birth_date  as "дата рождения"
from client c order by birth_date;

select c.client_id as "идентификатор клиента",
       full_name   as "ФИО",
       birth_date  as "дата рождения"
from client c
    order by
        extract(month from c.birth_date),
        extract(day from c.birth_date)