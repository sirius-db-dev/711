drop table if exists customers, orders cascade;

create table customers
(
	id integer primary key generated always as identity,
	name varchar(64) not null,
	surname varchar(64) not null,
	phone_number varchar(16) not null
);

insert into customers (name, surname, phone_number)
values
('Ahmed', 'Cool', '+79223334455'),
('Logan', 'Notbad', '+14567890044');

create table orders 
(
	id integer primary key generated always as identity,
	date date not null,
	sum integer not null,
	customer_id integer references customers(id) not null
);

insert into orders (date, sum, customer_id)
values
(now(), 1200, 1),
(now(), 21200, 1),
(now(), 1800, 2),
(now(), 41200, 2);

select
	c.id,
	c.name,
	c.surname,
	c.phone_number,
	coalesce(json_agg(json_build_object(
		'id', o.id,
		'date', o.date,
		'sum', o.sum
	)) filter(where o.id is not null), '[]') as orders
from customers c
left join orders o on c.id = o.customer_id
group by c.id
order by c.id;

drop table if exists customers, orders cascade;
