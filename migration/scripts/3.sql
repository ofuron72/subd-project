-- 3)всех служащих которые начали работать с 2025 года

select e.employee_id as "идентификатор", full_name as "ФИО",
       phone as "телефон",
       email as "email",
       hire_date "начало работы"
from employee e
    where e.hire_date > to_date('01-01-2021', 'DD-MM-YYYY');