drop table if exists conferences, presentations cascade;

create table conferences
(
	id int primary key,
	name text,
	conf_date date,
	address text
);

create table presentations
(
	id int primary key,
	conf_id int references conferences,
	name text,
	pres_date date,
	topic text
);

insert into conferences (id, name, conf_date, address)
values
(1, 'Конференция 1', '2023.09.01', 'г. Сочи ул. Ленина 1'),
(2, 'Конференция 2', '2023.08.01', 'г. Сочи ул. Лесная 12'),
(3, 'Конференция 3', '2023.07.01', 'г. Сочи ул. Шишкина 7'),
(4, 'Конференция 4', '2023.06.01', 'г. Сочи ул. Блкина 17');

insert into presentations (id, conf_id, name, pres_date, topic)
values
(1, 1, 'Кирилл', '2023.09.01', 'Тема 1'),
(2, 1, 'Иван', '2023.09.01', 'Тема 2'),
(3, 2, 'Владимир', '2023.08.01', 'Тема 3'),
(4, 2, 'Петр', '2023.08.01', 'Тема 4'),
(5, 3, 'Денис', '2023.07.01', 'Тема 5'),
(6, 3, 'Валентина', '2023.07.01', 'Тема 6');

select
	c.id,
	c.name,
	c.conf_date,
	c.address,
	coalesce(jsonb_agg(json_build_object(
		'id', p.id, 'name', p.name, 'pres_date', p.pres_date, 'topic', p.topic))
			filter (where p.id is not null), '[]') as presentations
from conferences c
left join presentations p on c.id = p.conf_id
group by c.id
order by c.id;