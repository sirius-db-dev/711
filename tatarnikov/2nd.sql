
create extension if not exists "uuid-ossp";

drop table if exists doctors, patients, docs_to_pats cascade;

create table doctors
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	spec text
);

create table patients
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date
);

create table docs_to_pats
(
	doc_id uuid references doctors,
	pat_id uuid references patients,
	primary key (doc_id, pat_id)
);

insert into doctors(first_name, last_name, spec)
values
('alex', 'ok', 'nurse'),
('pete', 'jsl', 'cooldude'),
('hsjka', 'ooooo', '123321');

insert into patients(first_name, last_name, birth_date)
values
('qwwe', 'fhjkdsfs', '1996-06-01'),
('hfjkds', 'bvbvbvvb', '1965-06-01'),
('fsfssf', 'aaaaaa', '2000-10-02');

insert into docs_to_pats(doc_id, pat_id)
values
((select id from doctors where first_name = 'alex'), (select id from patients where first_name = 'qwwe')),
((select id from doctors where first_name = 'pete'), (select id from patients where first_name = 'qwwe')),
((select id from doctors where first_name = 'hsjka'), (select id from patients where first_name = 'qwwe')),
((select id from doctors where first_name = 'alex'), (select id from patients where first_name = 'hfjkds')),
((select id from doctors where first_name = 'hsjka'), (select id from patients where first_name = 'fsfssf'));


select
  a.id,
  a.first_name,
  a.last_name,
  a.spec,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'name', f.first_name, 'surname', f.last_name, 'birth_date', f.birth_date))
      filter (where f.id is not null), '[]') as patients
from doctors a
left join docs_to_pats af on a.id = af.doc_id
left join patients f on f.id = af.pat_id
group by a.id;

select
  a.id,
  a.first_name,
  a.last_name,
  a.birth_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'name', f.first_name, 'surname', f.last_name, 'spec', f.spec))
      filter (where f.id is not null), '[]') as doctors
from patients a
left join docs_to_pats af on a.id = af.pat_id
left join doctors f on f.id = af.doc_id
group by a.id;
