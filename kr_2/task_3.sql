"""
Продукты и акции
на продукт может действовать несколько акций
акция может включать несколько продуктов
продукт - название, цена, категория
акция - название, размер скидки, дата начала, дата завершения
"""



create extension if not exists "uuid-ossp";

drop table if exists products, stock, products_stock cascade;

create table products
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	price int,
	category text
);

create table stock
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	amount_discount int,
	start_date date,
	end_date date
);

create table products_stock
(
	products_id uuid references products,
	stock_id uuid references stock,
	primary key (products_id, stock_id)
);

insert into products(title, price, category)
values
('titl111', 111, 'cat111'),
('titl222', 111, 'cat222'),
('titl333', 111, 'cat333'),
('titl444', 111, 'cat444'),
('titl555', 111, 'cat555');

insert into stock(title, amount_discount, start_date, end_date)
values
('stock111', 10, '2024-03-12', '2024-04-01'),
('stock222', 20, '2024-04-12', '2024-05-01'),
('stock333', 30, '2024-05-12', '2024-06-01'),
('stock444', 40, '2024-06-12', '2024-07-01'),
('stock555', 50, '2024-07-12', '2024-08-01');

insert into products_stock(products_id, stock_id)
values
(
	(select id from products where title = 'titl111'),
	(select id from stock where title = 'stock111')
),
(
	(select id from products where title = 'titl111'),
	(select id from stock where title = 'stock222')
),
(
	(select id from products where title = 'titl222'),
	(select id from stock where title = 'stock111')
),
(
	(select id from products where title = 'titl333'),
	(select id from stock where title = 'stock555')
),
(
	(select id from products where title = 'titl555'),
	(select id from stock where title = 'stock111')
),
(
	(select id from products where title = 'titl333'),
	(select id from stock where title = 'stock111')
),
(
	(select id from products where title = 'titl555'),
	(select id from stock where title = 'stock555')
),
(
	(select id from products where title = 'titl333'),
	(select id from stock where title = 'stock333')
);


select
	p.id,
	p.title,
	price,
	category,
	coalesce (json_agg(json_build_object(
		'title', s.title, 'amount_discount', s.amount_discount,
		'start_date', s.start_date, 'end_date', s.end_date))
			filter (where s.id is not null), '[]') as stock
from products p
left join products_stock ps on p.id = ps.products_id
left join stock s on s.id = ps.stock_id
group by p.id;


select
	s.id,
	s.title,
	amount_discount,
	start_date,
	end_date,
	coalesce (json_agg(json_build_object(
		'title', s.title, 'price', p.price, 'category', p.category))
			filter (where p.id is not null), '[]') as stock
from stock s 
left join products_stock ps on s.id = ps.stock_id
left join products p on p.id = ps.products_id
group by s.id;

