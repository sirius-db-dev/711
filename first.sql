drop table if exists drivers, orders cascade;

create table drivers
(
	id integer primary key generated always as identity,
	name varchar(64) not null,
	phone_number varchar(16) not null,
	car_name varchar(128) not null
);

insert into drivers (name, phone_number, car_name)
values
('Ahmed', '+79223334455', 'Nissan'),
('Logan', '+14567890044', 'Reno');

create table orders 
(
	id integer primary key generated always as identity,
	title varchar(128) not null,
	date date not null,
	sum integer not null,
	from_address varchar(128) not null,
	to_address varchar(128) not null,
	driver_id integer references drivers(id) not null
);

insert into orders (title, date, sum, from_address, to_address, driver_id)
values
('first', now(), 1200, 'start', 'end', 1),
('second', now(), 21200, 'start', 'end', 1),
('third', now(), 1800, 'start', 'end', 2),
('fourth', now(), 41200, 'start', 'end', 2);

select
	d.id,
	d.name,
	d.phone_number,
	d.car_name,
	coalesce(json_agg(json_build_object(
		'id', o.id,
		'title', o.title,
		'date', o.date,
		'sum', o.sum,
		'from_address', o.from_address,
		'to_address', o.to_address
	)) filter(where o.id is not null), '[]') as orders
from drivers d
left join orders o on d.id = o.driver_id
group by d.id
order by d.id;

drop table if exists drivers, orders cascade;
