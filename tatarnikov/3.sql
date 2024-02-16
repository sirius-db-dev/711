drop table if exists customers, orders;

create table customers
(
	id int primary key,
	first_name text,
	last_name text,
	phone_number text
);

create table orders
(
	order_id int primary key,
	client_id int references customers,
	order_date date,
	price int
	
);

insert into customers(id, first_name, last_name, phone_number)
values
(1, 'Pete', 'pete', '12345'),
(2, 'fufuf', 'fskdl', '1234324245');

insert into orders(order_id, client_id, order_date, price)
values
(1, 2, '2022.05.06', '100'),
(2, 2, '2023.04.03', '2223'),
(3, 1, '2023.07.08', '23223'),
(4, 1, '2023.10.09', '2563');


select 
  cs.id, 
  cs.first_name, 
  cs.last_name, 
  cs.phone_number,
  COALESCE(
  	json_agg(
  		json_build_object(
    			'id', ord.order_id, 
    			'client id', ord.client_id, 
    			'date', ord.order_date, 
    			'price', ord.price
    		)
    	) filter (where ord.order_id is not null),
    '[]'
    )
        as order_
from customers cs
left join orders ord on cs.id = ord.client_id
group by cs.id;