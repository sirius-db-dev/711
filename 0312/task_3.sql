/*
3. Доставки и курьеры:
у доставки может быть много курьеров
курьер может обслуживать несколько доставок
доставка - название, телефон
курьер - имя, фамилия, телефон, транспортное средство, объем сумки
*/


create extension if not exists "uuid-ossp";

drop table if exists deliveries, couriers, deliveries_to_couriers cascade;

create table deliveries
(
    id uuid primary key default uuid_generate_v4(),
    name text,
    phone text
);

create table couriers
(
    id uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    phone text,
    vehicle text,
    volume int
);

create table deliveries_to_couriers
(
    delivery_id uuid references deliveries,
    courier_id uuid references couriers,
    primary key (delivery_id, courier_id)
);

insert into deliveries(name, phone)
values ('блины с малиновым вареньем', '+7(999)111-11-11'),
       ('Nissan GTR', '+7(999)222-22-22'),
       ('набор тарелок белый', '+7(999)333-33-33'),
       ('коктейльный напиток со льдом', '+7(999)444-44-44'),
       ('no-name', '+7(999)999-99-99');

insert into couriers(first_name, last_name, phone, vehicle, volume)
values ('Илья', 'Данилов', '+7(999)111-11-11', 'тягач', 5000),
       ('Денис', 'Ромоданов', '+7(999)222-22-22', 'пешком', 35),
       ('Михаил', 'Тарасов', '+7(999)333-33-33', 'автомобиль', 500),
       ('no_name', 'no_name', '+7(999)999-99-99', 'велосипед', 35);

insert into deliveries_to_couriers(delivery_id, courier_id)
values
    ((select id from deliveries where name = 'блины с малиновым вареньем'),
     (select id from couriers where last_name = 'Данилов')),
    ((select id from deliveries where name = 'блины с малиновым вареньем'),
     (select id from couriers where last_name = 'Ромоданов')),
    ((select id from deliveries where name = 'Nissan GTR'),
     (select id from couriers where last_name = 'Данилов')),
    ((select id from deliveries where name = 'Nissan GTR'),
     (select id from couriers where last_name = 'Ромоданов')),
    ((select id from deliveries where name = 'набор тарелок белый'),
     (select id from couriers where last_name = 'Тарасов')),
    ((select id from deliveries where name = 'набор тарелок белый'),
     (select id from couriers where last_name = 'Ромоданов')),
    ((select id from deliveries where name = 'коктейльный напиток со льдом'),
     (select id from couriers where last_name = 'Тарасов')),
    ((select id from deliveries where name = 'коктейльный напиток со льдом'),
     (select id from couriers where last_name = 'Ромоданов'));

select
	deliveries.id,
	name,
	deliveries.phone,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', couriers.id,
		'first_name', couriers.first_name,
		'last_name', couriers.last_name,
		'phone', couriers.phone,
		'vehicle', couriers.vehicle,
		'volume', couriers.volume))
			filter (where couriers.id is not null), '[]') as couriers
from deliveries
left join deliveries_to_couriers on deliveries.id = deliveries_to_couriers.delivery_id
left join couriers on couriers.id = deliveries_to_couriers.courier_id
group by deliveries.id;