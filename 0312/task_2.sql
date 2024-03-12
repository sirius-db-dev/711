/*
2. Курсы и студенты
курсы могут проходить несколько студентов
студент может проходить нескольких курсах
курс - название, описание
студент - имя, фамилия, год поступления
*/


create extension if not exists "uuid-ossp";

drop table if exists courses, students, courses_to_students cascade;

create table courses
(
    id uuid primary key default uuid_generate_v4(),
    name text,
    description text
);

create table students
(
    id uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    admission_year int
);

create table courses_to_students
(
    course_id uuid references courses,
    student_id uuid references students,
    primary key (course_id, student_id)
);

insert into courses(name, description)
values
('Python', 'learn python'),
('super-duper-mega-extra-course', 'some super-duper-mega-extra text'),
('Kotlin', 'mobile developing'),
('C++', 'lets start solve tasks'),
('no-name', 'no-text');

insert into students(first_name, last_name, admission_year)
values
('Илья', 'Данилов', 2023),
('Денис', 'Ромоданов', 2023),
('Михаил', 'Тарасов', 2023),
('no_name', 'no_name', 0);

insert into courses_to_students(course_id, student_id)
values
    ((select id from courses where name = 'Python'),
     (select id from students where last_name = 'Данилов')),
    ((select id from courses where name = 'Python'),
     (select id from students where last_name = 'Ромоданов')),
    ((select id from courses where name = 'super-duper-mega-extra-course'),
     (select id from students where last_name = 'Данилов')),
    ((select id from courses where name = 'super-duper-mega-extra-course'),
     (select id from students where last_name = 'Ромоданов')),
    ((select id from courses where name = 'Kotlin'),
     (select id from students where last_name = 'Тарасов')),
    ((select id from courses where name = 'Kotlin'),
     (select id from students where last_name = 'Ромоданов')),
    ((select id from courses where name = 'C++'),
     (select id from students where last_name = 'Тарасов')),
    ((select id from courses where name = 'C++'),
     (select id from students where last_name = 'Ромоданов'));

select
	courses.id,
	name,
	description,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', students.id,
		'first_name', students.first_name,
		'last_name', students.last_name,
		'admission_year', students.admission_year))
			filter (where students.id is not null), '[]') as students
from courses
left join courses_to_students on courses.id = courses_to_students.course_id
left join students on students.id = courses_to_students.student_id
group by courses.id;