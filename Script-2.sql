create extension if not exists "uuid-ossp";
drop table if exists doctor, pacient, doctor_to_pacient cascade;


create table doctor (id uuid primary key default uuid_generate_v4(), name text, surname text, special text);
create table pacient (id uuid primary key default uuid_generate_v4(), name text, surname text, birth_date text);
create table doctor_to_pacient (doctor_id uuid references doctor, pacient_id uuid references pacient, primary key (doctor_id, pacient_id));


insert into doctor(name, surname, special)
values 
('Gena', 'Oval', 'pediatr'),
('Lena', 'Kvadrat', 'ovtalmolog'),
('Vanya', 'Tri', 'terapevt'),
('Katya', 'Kvadrat', 'hirurg');

insert into pacient(name, surname, birth_date)
values 
('Ilya', 'Lib', '21-08-2000'),
('Sasha', 'Resp', '12-05-1999'),
('Anton', 'Comm', '16-11-2013'),
('Alina', 'Neital', '31-12-2005');


insert into doctor_to_pacient(doctor_id, pacient_id)
values
((select id from doctor where name = 'Gena'), (select id from pacient where name = 'Anton')),
((select id from doctor where name = 'Lena'), (select id from pacient where name = 'Ilya')),
((select id from doctor where name = 'Lena'), (select id from pacient where name = 'Anton')),
((select id from doctor where name = 'Vanya'), (select id from pacient where name = 'Alina')),
((select id from doctor where name = 'Katya'), (select id from pacient where name = 'Alina'));


select * from doctor
				left join doctor_to_pacient on doctor.id = doctor_to_pacient.doctor_id
				left join pacient on doctor_to_pacient.pacient_id = pacient.id;
				
select
  doctor.name,
  doctor.surname,
  doctor.special,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', pacient.id, 'name', pacient.name, 'surname', pacient.surname, 'birth_date', pacient.birth_date))
      filter (where pacient.id is not null), '[]') as pacient
from doctor
	left join doctor_to_pacient on doctor.id = doctor_to_pacient.doctor_id
	left join pacient on pacient.id = doctor_to_pacient.pacient_id
group by doctor.id;

select
  pacient.name,
  pacient.surname,
  pacient.birth_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', doctor.id, 'name', doctor.name, 'surname', doctor.surname, 'birth_date', doctor.special))
      filter (where doctor.id is not null), '[]') as doctor
from pacient
	left join doctor_to_pacient on pacient.id = doctor_to_pacient.pacient_id
	left join doctor on doctor.id = doctor_to_pacient.doctor_id
group by pacient.id;		
