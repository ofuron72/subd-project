-- Напишите запрос для определения количества изучаемых предметов на
-- каждом курсе.

select st.kurs            as "Курс",
       count(s.subj_name) as "Количество предметов на курсе"
from student st
         join public.exam_marks em on st.student_id = em.student_id
         join public.subject s on s.subj_id = em.subj_id
group by st.kurs;