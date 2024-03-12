
create extension if not exists "uuid-ossp";

drop table if exists taxi_drivers, aggregators, agg_to_taxi cascade;

create table taxi_drivers
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	phone text,
	car text
);

create table aggregators
(
	id uuid primary key default uuid_generate_v4(),
	agg_name text,
	phone text
);

create table agg_to_taxi
(
	agg_id uuid references aggregators,
	taxi_id uuid references taxi_drivers,
	primary key (agg_id, taxi_id)
);

insert into taxi_drivers(first_name, last_name, phone, car)
values
('alex', 'ok', '478239', 'okokok'),
('pete', 'jsl', '36782136781', 'some'),
('hsjka', 'ooooo', '123321', 'porshe');

insert into aggregators(agg_name, phone)
values
('qwwe', '1822390428'),
('hfjkds', '1909090'),
('fsfssf', '200012121');

insert into agg_to_taxi(doc_id, pat_id)
values
((select id from taxi_drivers where first_name = 'alex'), (select id from aggregators where agg_name = 'qwwe')),
((select id from taxi_drivers where first_name = 'pete'), (select id from aggregators where agg_name = 'qwwe')),
((select id from taxi_drivers where first_name = 'hsjka'), (select id from aggregators where agg_name = 'qwwe')),
((select id from taxi_drivers where first_name = 'alex'), (select id from aggregators where agg_name = 'hfjkds')),
((select id from taxi_drivers where first_name = 'hsjka'), (select id from aggregators where agg_name = 'fsfssf'));


select
  a.id,
  a.first_name,
  a.last_name,
  a.phone,
  a.car,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'name', f.agg_name))
      filter (where f.id is not null), '[]') as aggregators
from taxi_drivers a
left join agg_to_taxi af on a.id = af.doc_id
left join aggregators f on f.id = af.pat_id
group by a.id;

select
  a.id,
  a.agg_name,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'name', f.first_name, 'surname', f.last_name, 'phone', f.phone, 'car', f.car))
      filter (where f.id is not null), '[]') as taxi_drivers
from aggregators a
left join agg_to_taxi af on a.id = af.pat_id
left join taxi_drivers f on f.id = af.doc_id
group by a.id;
