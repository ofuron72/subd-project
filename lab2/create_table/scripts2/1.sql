--1. Напишите запрос, выполняющий вывод находящихся в таблице EXAM_MARKS
-- номеров предметов обучения,
-- экзамены по которым сдавались между 10 и 20 января 1999 года.
--

select em.exam_id as "Номер предмета",
       em.exam_date as "Дата экзамена"
from exam_marks em where em.exam_date
    between to_date('10-01-2000','dd-mm-yyyy') and to_date('20-01-2000','dd-mm-yyyy');



