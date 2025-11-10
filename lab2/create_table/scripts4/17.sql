-- Напишите запрос для получения среднего балла для каждого студента.

select st.name      as "Имя студента",
       avg(em.mark) as "Средний балл"
from student st
         join public.exam_marks em on st.student_id = em.student_id
group by st.name;