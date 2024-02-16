drop table if exists teams, workers cascade;

create table teams
(
	id int primary key,
	name text,
	date_create date
);

create table workers
(
	id int primary key,
	team_id int references teams,
	first_name text,
	last_name text,
	post text
);

insert into teams (id, name, date_create)
values
(1, 'Разработчики', '2023.09.01'),
(2, 'Продажники', '2023.08.02'),
(3, 'Тех поддержка', '2023.07.03'),
(4, 'Бухгалтерия', '2023.06.04');

insert into workers (id, team_id, first_name, last_name, post)
values
(1, 1, 'Кирилл', 'Иноземцев', 'FRONT-END'),
(2, 1, 'Иван', 'Будько', 'BACK-END'),
(3, 2, 'Владимир', 'Иванов', 'Директор'),
(4, 2, 'Петр', 'Васильев', 'Помошник'),
(5, 3, 'Денис', 'Верхотуров', 'Опператор'),
(6, 3, 'Валентина', 'Иноземцева', 'Тестировщик');

select
	t.id,
	t.name,
	t.date_create,
	coalesce(jsonb_agg(json_build_object(
		'id', w.id, 'first_name', w.first_name, 'last_name', w.last_name, 'post', w.post))
			filter (where w.id is not null), '[]') as workers
from teams t
left join workers w on t.id = w.team_id
group by t.id
order by t.id;