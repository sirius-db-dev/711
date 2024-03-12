"""
Врачи и пациенты:
врач может лечить несколько пациентов
пациент может лечиться у нескольких врачей
врач - имя, фамилия, специализация
пациент - имя, фамилия, дата рождения
"""



create extension if not exists "uuid-ossp";

drop table if exists doctors, patients, doctors_patients cascade;

create table doctors
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birthdate date
);

create table patients
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birthdate date
);

create table doctors_patients
(
	doctord_id uuid references doctors,
	patients_id uuid references patients,
	primary key (doctord_id, patients_id)
);

insert into doctors(first_name, last_name, birthdate)
values
('doctor111', 'doctor111', '2001-11-11'),
('doctor222', 'doctor222', '2001-12-12'),
('doctor333', 'doctor333', '2001-11-13'),
('doctor444', 'doctor444', '2001-11-14'),
('doctor555', 'doctor555', '2001-11-15');


insert into patients(first_name, last_name, birthdate)
values
('patient111', 'doctor111', '2001-11-11'),
('patient222', 'doctor222', '2001-12-12'),
('patient333', 'doctor333', '2001-11-13'),
('patient444', 'doctor444', '2001-11-14'),
('patient555', 'doctor555', '2001-11-15');


insert into doctors_patients(doctord_id, patients_id)
values
(
(select id from doctors where first_name = 'doctor111'),
(select id from patients where first_name = 'patient111')
),
(
(select id from doctors where first_name = 'doctor111'),
(select id from patients where first_name = 'patient222')
),
(
(select id from doctors where first_name = 'doctor111'),
(select id from patients where first_name = 'patient333')
),
(
(select id from doctors where first_name = 'doctor222'),
(select id from patients where first_name = 'patient111')
),
(
(select id from doctors where first_name = 'doctor555'),
(select id from patients where first_name = 'patient333')
),
(
(select id from doctors where first_name = 'doctor555'),
(select id from patients where first_name = 'patient555')
),
(
(select id from doctors where first_name = 'doctor555'),
(select id from patients where first_name = 'patient222')
),
(
(select id from doctors where first_name = 'doctor333'),
(select id from patients where first_name = 'patient111')
);


select 
	d.id,
	d.first_name,
	d.last_name,
	d.birthdate,
	coalesce(json_agg(json_build_object(
		'id', p.id, 'first_name', p.first_name, 'last_name', p.last_name, 'birthdate', p.birthdate))
			filter (where p.id is not null), '[]') as patients
from doctors d
left join doctors_patients dp on d.id = dp.doctord_id
left join patients p on p.id = dp.patients_id
group by d.id;


select 
	p.id,
	p.first_name,
	p.last_name,
	p.birthdate,
	coalesce(json_agg(json_build_object(
		'id', d.id, 'first_name', d.first_name, 'last_name', d.last_name, 'birthdate', d.birthdate))
			filter (where d.id is not null), '[]') as doctors
from patients p
left join doctors_patients dp on p.id = dp.patients_id
left join doctors d on d.id = dp.doctord_id
group by p.id;
