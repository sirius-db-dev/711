drop table if exists companies, employees cascade;

create table companies 
(
	id integer primary key generated always as identity,
	title varchar(64) not null,
	creating_date date not null
);

insert into companies (title, creating_date)
values
('Samsung', now()),
('Google', now());

create table employees
(
	id integer primary key generated always as identity,
	name varchar(64) not null,
	surname varchar(64) not null,
	job varchar(64) not null,
	company_id integer references companies(id) not null
);

insert into employess (name, surname, job, company_id)
values
('Ahmed', 'Cool', 'programer', 1),
('Logan', 'Notbad', 'manager', 1),
('Harry', 'Potter', 'builder', 2),
('Peter', 'Parker', 'hero', 2);

select
	c.id,
	c.title,
	c.creating_date,
	coalesce(json_agg(json_build_object(
		'id', e.id,
		'name', e.name,
		'surname', e.surname,
		'job', e.job
	)) filter(where e.id is not null), '[]') as employees
from companies c
left join employess e on c.id = e.company_id
group by c.id
order by c.id;

drop table if exists companies, employees cascade;
