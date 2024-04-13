drop table if exists orders, taxist cascade;

create table taxist(
id int primary key, 
name_taxist text,
second_name text,
phone text,
car text
);


create table orders(
id int primary key, 
id_taxist int references taxist,
name_order text,
date_order date,
price int,
address_start text,
address_stop text
);

insert into taxist(id, name_taxist, second_name, phone, car) values
(1, 'a', 'b', '8978123412', 'seven'),
(2, 'c', 'd',  '4127384783', 'eight'),
(3, 'n', 'm',  '5423467221', 'nine');

insert into orders(id, id_taxist, name_order, date_order, price, address_start, address_stop) values
(1, 1, 'order1', '05-06-2012', 1234, 'punktA', 'punktB'),
(2, 1, 'order2', '05-06-2012', 576, 'punktC', 'punktV'),
(3, 3, 'order1', '05-06-2012', 435, 'punktA', 'punktB');

select * from taxist;
select * from orders;

select taxist.id, taxist.name_taxist, taxist.second_name, taxist.phone, taxist.car,
coalesce(json_agg(json_build_object(
'id', orders.id, 'name_order', orders.name_order, 'date_order', orders.date_order, 'price', orders.price, 'address_start', orders.address_start, 'address_stop', orders.address_stop))
filter(where orders.id is not null), '[]') as orders
from taxist
left join orders on taxist.id = orders.id_taxist
group by taxist.id;