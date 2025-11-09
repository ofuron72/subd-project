-- 1)отсортировать клиентов по дню рождению,

-- 3)всех служащих которые начали работать с 2025 года
-- 4) вывести все транзацкии за день, и типу валюты,
--  и выводим транзакции за день по определенному типу валюты

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