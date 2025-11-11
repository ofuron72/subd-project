-- 6. То же, что и в задании 4, но только для студентов 1, 2 и 4-го курсов,
-- и таким образом,
-- чтобы фамилии и имена были выведены прописными (заглавными) буквами.

select concat(upper(s.name), ' ', upper(s.surname), ' родился в ',
              to_char(s.birthday, 'YYYY'), ' году') as
           "Год рождения",
    s.kurs as "Курс"
from student s
where s.birthday is not null
  and s.kurs in (1, 2, 4);