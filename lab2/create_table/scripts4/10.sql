--10. Напишите запрос, который позволяет подсчитать в таблице EXAM_MARKS
-- количество различных предметов обучения.

select count(distinct em.subj_id) from exam_marks em;