-- Напишите запрос на выдачу данных о названиях всех предметов,
-- по которым студенты получили только хорошие (оценки 4 и 5).
-- В выходных данных должны быть приведены фамилии студентов,
-- названия предметов и оценки.

SELECT
    s.surname,
    sub.subj_name,
    em.mark
FROM exam_marks em
         JOIN student s ON em.student_id = s.student_id
         JOIN subject sub ON em.subj_id = sub.subj_id
WHERE em.mark IN (4, 5)
  AND em.subj_id NOT IN (
    SELECT subj_id
    FROM exam_marks
    WHERE mark < 4 OR mark IS NULL
);