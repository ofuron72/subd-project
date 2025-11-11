-- 11. Напишите запрос, который выполняет выборку для каждого студента —
-- его идентификатор и минимальную из полученных им оценок.

select s.student_id as "Идентификатор студента",
       min(em.mark) as "Минимальная оценка"
from student s
         join public.exam_marks em on s.student_id = em.student_id
group by s.student_id;