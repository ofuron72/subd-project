--2. Напишите запрос, выбирающий данные обо всех предметах обучения,
-- экзамены по которым сданы студентами, имеющими идентификаторы 12 и 32.

select s.subj_id as "номер предмета",
       s.subj_name as "название предмета",
       s.hour as "часы",
       s.semester as "семестр",
       st.student_id "идентификатор студента"
from subject s join public.exam_marks em
    on s.subj_id = em.subj_id
join public.student st
    on st.student_id = em.student_id
where st.student_id in (12, 32);