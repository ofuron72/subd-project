-- 6. Напишите запрос, выполняющий вывод из таблицы EXAM_MARKS записей,
-- для которых в поле MARK проставлены значения оценок.

select exam_id    as "Номер экзамена",
       student_id as "Номер студента",
       subj_id    as "Номер предмета",
       mark       as "оценка",
       exam_date  as "дата экзамена"
from exam_marks em
where em.mark is not null;