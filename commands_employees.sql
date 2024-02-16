drop table if exists commands, employees, employees_to_commands cascade;

create table commands
(
	id int primary key,
	title_commands text,
	date_of_create text
);

create table employees
(	
	id int primary key,
	first_name text,
	last_name text,
	position_employee text
);

create table employees_to_commands
(
	employees_id int references employees,
	commands_id int references commands,
	primary key(employees_id, commands_id)
);

insert into commands(id, title_commands, date_of_create)
values
(1, 'Command1', '2021-02-25'),
(2, 'Command2', '2022-08-12'),
(3, 'Command3', '2022-04-14');

insert into employees(id, first_name, last_name, position_employee)
values
(1, 'Alexey', 'Suvorov', 'Ingeneer'),
(2, 'Efrem', 'Krilov', 'Manager'),
(3, 'Boris', 'Novikov', 'Driver'),
(4, 'Marina', 'Orlova', 'Officiant');

insert into employees_to_commands(employees_id, commands_id)
values 
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(3, 2),
(3, 1);

select 
	cm.id,
	cm.title_commands,
	cm.date_of_create,
	coalesce(json_agg(jsonb_build_object('id', em.id, 'first_name', em.first_name, 
	'last_name',em.last_name, 'position_employee', em.position_employee))
	filter(where em.id is not null), '[]') as employees
from commands cm
left join employees_to_commands ec on cm.id = ec.commands_id
left join employees em on em.id = ec.employees_id
group by cm.id;

select 
	em.id,
	em.first_name,
	em.last_name,
	em.position_employee,
	coalesce(json_agg(jsonb_build_object('id', cm.id, 'title_commands', cm.title_commands, 
	'date_of_create',cm.date_of_create))
	filter(where cm.id is not null), '[]') as commands
from employees as em
left join employees_to_commands ec on em.id = ec.employees_id
left join commands cm on em.id = ec.commands_id
group by em.id;

