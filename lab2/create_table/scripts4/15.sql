-- Напишите запрос, который выполняет вывод данных для каждого
-- конкретного дня сдачи экзамена
-- о количестве студентов, сдававших экзамен в этот день.

select count(s.student_id)
from exam_marks
         join public.student s on s.student_id = exam_marks.student_id
group by exam_marks.exam_date::date;
