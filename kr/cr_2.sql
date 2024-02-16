drop table if exists products, reviews;

create table products
(
	id int primary key,
	title text,
	description text,
	price int
);

create table reviews
(
	product_id int references products,
	text text,
	grade int
);

insert into products (id, title, description, price)
values
(1, 'товар 1', 'тут что то написано', 999),
(2, 'товар 2', 'тут что то написано', 888),
(3, 'товар 3', 'тут что то написано', 777),
(4, 'товар 4', 'тут что то написано', 666);

insert into reviews (product_id, text, grade)
values
(1, 'Мои глаза ААА!', 1),
(2, 'Лучшее что я покупал', 10),
(3, 'Что это?', 4),
(1, 'Hello wordl', 8);

select 
	id,
	title,
	description,
	price,
	coalesce (json_agg(json_build_object(
	'text', r.text, 'grade', r.grade))
		filter (where r.text is not null), '[]') as reviews
from products p
left join reviews r on p.id = r.product_id
group by p.id;
