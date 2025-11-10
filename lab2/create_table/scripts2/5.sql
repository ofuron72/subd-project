--5. Напишите запрос для выбора из таблицы EXAM_MARKS записей,
-- для которых отсутствуют значения оценок (поле MARK).
--

select exam_id    as "Номер экзамена",
       student_id as "Номер студента",
       subj_id    as "Номер предмета",
       mark       as "оценка",
       exam_date  as "Дата экзамена"
from exam_marks em
where em.mark is null;