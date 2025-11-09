-- 2)имя клиента и его количество счетов

select c.full_name as "имя клиента",
       count(c.full_name)
from client c
         left join account a on (c.client_id = a.client_id)
group by c.full_name;