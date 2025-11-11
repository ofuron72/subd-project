-- 16. Напишите запрос для получения среднего балла для каждого курса по каждому предмету.

select subj.subj_name as "Предмет",
       s.kurs as "курс",
       avg(em.mark) as "средний балл"
from exam_marks em
         join public.student s on s.student_id = em.student_id
         join public.subject subj on subj.subj_id = em.subj_id
group by (s.kurs, subj.subj_name);