create extension if not exists "uuid-ossp";

drop table if exists couriers, deliveries, courier_to_delivery cascade;


create table couriers
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	phone text,
	transport text,
	volume int
	
);

create table deliveries
(
	id uuid primary key default uuid_generate_v4(),
	delivery_name text,
	delivery_phone text
);

create table courier_to_delivery
(
	courier_id uuid references couriers not null,
	delivery_id uuid references deliveries not null,
	unique(courier_id, delivery_id)
);

insert into couriers (first_name, last_name, phone, transport, volume)
values
('Иван', 'Иванов', '+79139999999', 'Велосипед', 3),
('Валерий', 'Верхотуров', '+79138888888', 'Машина', 1),
('Семен', 'Бакин', '+79137777777','Велосипед', 6);

insert into deliveries (delivery_name, delivery_phone)
values
('Доставка 1', '+79039999999'),
('Доставка 2', '+79038888888'),
('Доставка 3', '+79037777777');

insert into courier_to_delivery (courier_id, delivery_id)
values
((select id from couriers where last_name = 'Иванов'), (select id from deliveries where delivery_name = 'Доставка 1')),
((select id from couriers where last_name = 'Иванов'), (select id from deliveries where delivery_name = 'Доставка 2')),
((select id from couriers where last_name = 'Верхотуров'), (select id from deliveries where delivery_name = 'Доставка 1')),
((select id from couriers where last_name = 'Верхотуров'), (select id from deliveries where delivery_name = 'Доставка 3')),
((select id from couriers where last_name = 'Бакин'), (select id from deliveries where delivery_name = 'Доставка 2')),
((select id from couriers where last_name = 'Бакин'), (select id from deliveries where delivery_name = 'Доставка 3'));

select
	d.id,
	d.delivery_name,
	d.delivery_phone,
	coalesce(jsonb_agg(json_build_object(
		'id', c.id, 'first_name', c.first_name, 'last_name', c.last_name, 'phone', c.phone, 'transport', c.transport, 'volume', c.volume))
		filter (where c.id is not null), '[]') as couriers
from deliveries d
left join courier_to_delivery cd on d.id = cd.delivery_id
left join couriers c on c.id = cd.courier_id
group by d.id
order by d.id;

select
	c.first_name,
	c.last_name,
	c.phone,
	c.transport,
	c.volume,
	coalesce(jsonb_agg(json_build_object(
		'id', d.id, 'delivery_name', d.delivery_name, 'delivery_phone', d.delivery_phone))
		filter (where d.id is not null), '[]') as deliveries
from couriers c
left join courier_to_delivery cd on c.id = cd.courier_id
left join deliveries d on d.id = cd.delivery_id
group by c.id
order by c.id;