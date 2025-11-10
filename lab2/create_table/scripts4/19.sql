-- Напишите запрос для определения количества студентов, сдававших каждый экзамен.

select em.subj_id as "идентификатор предмета",
       count(*)   as "количество студентов"
from student
         join public.exam_marks em
              on student.student_id = em.student_id
group by em.subj_id;