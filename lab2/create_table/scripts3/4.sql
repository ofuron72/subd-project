--4. Составьте запрос для таблицы STUDENT таким образом,
-- чтобы выходная таблица содержала всего один столбец следующего вида:
--
-- Борис Кузнецов родился в 1981 году.

select concat(s.name, ' ', s.surname, ' родился в ', to_char(s.birthday, 'YYYY'), ' году') as
           "Год рождения"
from student s
where s.birthday is not null;