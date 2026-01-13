-- Напишите запрос, который выполняет вывод данных о фамилиях студентов,
-- сдававших экзамены,
-- вместе с наименованиями каждого сданного ими предмета обучения.

SELECT
    s.surname,
    sub.subj_name
FROM exam_marks em
         JOIN student s ON em.student_id = s.student_id
         JOIN subject sub ON em.subj_id = sub.subj_id;