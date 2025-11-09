CREATE TABLE university
(
    univ_id   BIGINT PRIMARY KEY,
    univ_name VARCHAR(128) NOT NULL,
    rating    INTEGER,
    city      VARCHAR(128)
);

comment on table university is 'Университеты';
comment on column university.univ_id is 'идентификатор университета';
comment on column university.univ_name is 'название университета';
comment on column university.rating is 'рейтинг университета';
comment on column university.city is 'город, в котором расположен университет';

CREATE TABLE student
(
    student_id BIGINT PRIMARY KEY,
    surname    VARCHAR(128) NOT NULL,
    name       VARCHAR(128) NOT NULL,
    stipend    NUMERIC(10, 2),
    kurs       INTEGER,
    city       VARCHAR(128),
    birthday   TIMESTAMPTZ,
    univ_id    BIGINT REFERENCES university (univ_id)
);

comment on table student is 'Студент';
comment on column student.student_id is 'числовой код, идентифицирующий студента';
comment on column student.surname is 'фамилия студента';
comment on column student.name is 'имя студента';
comment on column student.stipend is 'стипендия, которую получает студент';
comment on column student.kurs is 'курс, на котором учится студент';
comment on column student.city is 'город, в котором живет студент';
comment on column student.birthday is 'дата рождения студента';
comment on column student.univ_id is 'числовой код, идентифицирующий университет, в
котором учится студент';

CREATE TABLE lecturer
(
    lecturer_id BIGINT PRIMARY KEY,
    surname     VARCHAR(128) NOT NULL,
    name        VARCHAR(128) NOT NULL,
    city        VARCHAR(128),
    univ_id     BIGINT REFERENCES university (univ_id)
);

comment on table lecturer is 'Преподаватель';
comment on column lecturer.lecturer_id is 'идентификатор университета';
comment on column lecturer.surname is 'название университета';
comment on column lecturer.name is 'рейтинг университета';
comment on column lecturer.city is 'город, в котором расположен университет';
comment on column lecturer.univ_id is 'идентификатор университета, в котором работает
преподаватель';

CREATE TABLE subject
(
    subj_id   BIGINT PRIMARY KEY,
    subj_name VARCHAR(128) NOT NULL,
    hour      INTEGER,
    semester  INTEGER
);

comment on table subject is 'Предмет обучения';
comment on column subject.subj_id is 'идентификатор предмета обучения';
comment on column subject.subj_name is 'наименование предмета обучения';
comment on column subject.hour is 'рейтинг университета';
comment on column subject.semester is 'семестр, в котором изучается данный предмет';

CREATE TABLE exam_marks
(
    exam_id    BIGINT PRIMARY KEY,
    student_id BIGINT REFERENCES student (student_id),
    subj_id    BIGINT REFERENCES subject (subj_id),
    mark       INTEGER CHECK (mark BETWEEN 2 AND 5 OR mark IS NULL),
    exam_date  TIMESTAMPTZ
);

comment on table exam_marks is 'Экзаменационные оценки';
comment on column exam_marks.exam_id is 'идентификатор экзамена';
comment on column exam_marks.student_id is 'идентификатор студента';
comment on column exam_marks.subj_id is 'идентификатор предмета обучения';
comment on column exam_marks.mark is 'экзаменационная оценка';
comment on column exam_marks.exam_date is 'экзаменационная оценка';

CREATE TABLE subj_lect
(
    lecturer_id BIGINT REFERENCES lecturer (lecturer_id),
    subj_id     BIGINT REFERENCES subject (subj_id),
    PRIMARY KEY (lecturer_id, subj_id)
);

comment on table subj_lect is 'Учебные дисциплины преподавателей';
comment on column subj_lect.lecturer_id is 'идентификатор преподавателя';
comment on column subj_lect.subj_id is 'идентификатор предмета обучения';