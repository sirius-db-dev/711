"""
Рецепты и ингредиенты
ингридиент может быть использован в нескольких рецептах
рецепт может использовать несколько ингредиентов
ингридиент - название, категория, цена
рецепт - название, описание, категория
"""



create extension if not exists "uuid-ossp";

drop table if exists recipes, ingredients, recipes_ingredients cascade;

create table ingredients
(
	id uuid primary key default uuid_generate_v4(),
	category text,
	title text,
	price int
);

create table recipes
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	descriptoin_category text
);

create table recipes_ingredients
(
	recipes_id uuid references recipes,
	ingredients_id uuid references ingredients,
	primary key (recipes_id, ingredients_id)
);

insert into ingredients(category, title, price)
values
('cat111', 'title111', 111),
('cat222', 'title222', 222),
('cat333', 'title333', 333),
('cat444', 'title444', 444),
('cat555', 'title555', 555);

insert into recipes(title, descriptoin_category)
values
('title111', 'descp111'),
('title222', 'descp222'),
('title333', 'descp333'),
('title444', 'descp444'),
('title555', 'descp555');

insert into recipes_ingredients(recipes_id, ingredients_id)
values
(
	(select id from recipes where title = 'title111'),
	(select id from ingredients where title = 'title111')
),
(
	(select id from recipes where title = 'title222'),
	(select id from ingredients where title = 'title111')
),
(
	(select id from recipes where title = 'title111'),
	(select id from ingredients where title = 'title222')
),
(
	(select id from recipes where title = 'title333'),
	(select id from ingredients where title = 'title333')
),
(
	(select id from recipes where title = 'title555'),
	(select id from ingredients where title = 'title333')
),
(
	(select id from recipes where title = 'title333'),
	(select id from ingredients where title = 'title555')
);


select
	r.id,
	r.title,
	descriptoin_category,
	coalesce (json_agg(json_build_object(
		'title', i.title, 'category', i.category, 'price', i.price))
			filter (where i.id is not null), '[]') as ingredients
from recipes r
left join recipes_ingredients ri on r.id = ri.recipes_id
left join ingredients i on i.id = ri.ingredients_id
group by r.id;


select
	i.id,
	i.title,
	category,
	price,
	coalesce (json_agg(json_build_object(
		'title', r.title, 'descriptoin_category', r.descriptoin_category))
			filter (where r.id is not null), '[]') as recipes
from ingredients i
left join recipes_ingredients ri on i.id = ri.ingredients_id
left join recipes r on r.id = ri.recipes_id
group by i.id;
