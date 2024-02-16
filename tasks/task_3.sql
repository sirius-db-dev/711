/*
3. Поставщики и транспортные средства:
поставщик может иметь несколько транспортных средств
транспортное средство может принадлежать только одному поставщику
поставщик - название, телефон
транспортное средство - марка, модель, грузоподъемность
*/


drop table if exists suppliers, vehicles cascade;

create table suppliers
(
	id int primary key,
	name text,
	phone text
);

create table vehicles
(
	id int primary key,
	supplier_id int references suppliers(id),
	brand text,
	model text,
	load_capacity int
);

insert into suppliers(id, name, phone)
values
(1, 'Александр Коренякин', '+79991111111'),
(2, 'Денис Ромоданов', '+79992222222'),
(3, 'Поставщик без транспортных средств', '+79993333333');

insert into vehicles(id, supplier_id, brand, model, load_capacity)
values
(1, 2, 'Lada', 'Granta', 2000),
(2, 1, 'Wolksvagen', 'Q6', 9999),
(3, 1, 'Subary', 'Supra', 5000),
(4, 2, 'No-name', 'Super-Duper-Extra-Mega_Car', 3);

select
	suppliers.id,
	name,
	phone,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', vehicles.id,
		'brand', vehicles.brand,
		'model', vehicles.model,
		'load_capacity', vehicles.load_capacity))
			filter (where vehicles.id is not null), '[]') as vehicles
from suppliers
left join vehicles on suppliers.id = vehicles.supplier_id
group by suppliers.id
order by suppliers.id asc;
