-- Напишите запрос, который выполняет вывод списка университетов с рейтингом,
-- превышающим 300, вместе со значением максимального размера стипендии,
-- получаемой студентами в этих университетах.

SELECT
    u.univ_name,
    u.rating,
    MAX(s.stipend) AS max_stipend
FROM university u
         JOIN student s ON u.univ_id = s.univ_id
WHERE u.rating > 300
GROUP BY
    u.univ_id,
    u.univ_name,
    u.rating;