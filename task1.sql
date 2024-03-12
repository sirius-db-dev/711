create extension if not exists "uuid-ossp";

drop table if exists teachers, universities, teach_to_university cascade;


create table teachers
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date,
	academic_degree int,
	expirience int
	
);

create table universities
(
	id uuid primary key default uuid_generate_v4(),
	universitiy_name text,
	universitiy_adress text
);

create table teach_to_university
(
	teacher_id uuid references teachers not null,
	universitiy_id uuid references universities not null,
	unique(teacher_id, universitiy_id)
);

insert into teachers (first_name, last_name, birth_date, academic_degree, expirience)
values
('Иван', 'Иванов', '2000.07.09', 2, 3),
('Валерий', 'Верхотуров', '2003.02.01', 1, 1),
('Семен', 'Бакин', '1996.05.11', 3, 6);

insert into universities (universitiy_name, universitiy_adress)
values
('Университет Сириус', 'пгт. Сириус ул. Олимпийский 1'),
('ИТМО', 'г. Санкт-питербург ул. Ленина 14'),
('ТПУ', 'г. Томск ул. Ломоносова 23');

insert into teach_to_university (teacher_id, universitiy_id)
values
((select id from teachers where last_name = 'Иванов'), (select id from universities where universitiy_name = 'Университет Сириус')),
((select id from teachers where last_name = 'Иванов'), (select id from universities where universitiy_name = 'ИТМО')),
((select id from teachers where last_name = 'Верхотуров'), (select id from universities where universitiy_name = 'Университет Сириус')),
((select id from teachers where last_name = 'Верхотуров'), (select id from universities where universitiy_name = 'ТПУ')),
((select id from teachers where last_name = 'Бакин'), (select id from universities where universitiy_name = 'ИТМО')),
((select id from teachers where last_name = 'Бакин'), (select id from universities where universitiy_name = 'ТПУ'));

select
	u.id,
	u.universitiy_name,
	u.universitiy_adress,
	coalesce(jsonb_agg(json_build_object(
		'id', t.id, 'first_name', t.first_name, 'last_name', t.last_name, 'birth_date', t.birth_date, 'academic_degree', t.academic_degree, 'expirience', t.expirience))
		filter (where t.id is not null), '[]') as teachers
from universities u
left join teach_to_university tu on u.id = tu.universitiy_id
left join teachers t on t.id = tu.teacher_id
group by u.id
order by u.id;

select
	t.first_name,
	t.last_name,
	t.birth_date,
	t.academic_degree,
	t.expirience,
	coalesce(jsonb_agg(json_build_object(
		'id', u.id, 'universitiy_name', u.universitiy_name, 'universitiy_adress', u.universitiy_adress))
		filter (where u.id is not null), '[]') as universities
from teachers t
left join teach_to_university tu on t.id = tu.teacher_id
left join universities u on u.id = tu.universitiy_id
group by t.id
order by t.id;