create extension if not exists "uuid-ossp";

drop table if exists ingredients, recipes, ingredients_recipes cascade;

create table if not exists ingredients (
	id uuid primary key default uuid_generate_v4(),
	title varchar(128) not null,
	category varchar(128) not null default 'food',
	price decimal not null default 100
);

create table if not exists recipes (
	id uuid primary key default uuid_generate_v4(),
	title varchar(128) not null,
	category varchar(128) not null default 'kitchen',
	description text not null
);

create table if not exists ingredients_recipes (
	ingredient_id uuid,
	recipe_id uuid,

	primary key (ingredient_id, recipe_id)
);


insert into ingredients (title)
values
	('i_first'),
	('i_second'),
	('i_third');

insert into recipes (title, description)
values
	('r_first', 'd_first'),
	('r_second', 'd_second'),
	('r_third', 'd_thrid');

insert into ingredients_recipes (ingredient_id, recipe_id)
values
	((select id from ingredients where title = 'i_first'), (select id from recipes where title = 'r_first')),
	((select id from ingredients where title = 'i_first'), (select id from recipes where title = 'r_second')),
	((select id from ingredients where title = 'i_second'), (select id from recipes where title = 'r_third'));


select
	i.id,
	i.title,
	i.category,
	i.price,
	coalesce (jsonb_agg(jsonb_build_object(
		'id', r.id,
		'title', r.title,
		'category', r.category,
		'description', r.description
	)) filter (where r.id is not null), '[]') as recipes
from ingredients i
left join ingredients_recipes ir on i.id = ir.ingredient_id
left join recipes r on r.id = ir.recipe_id
group by i.id;

select
	r.id,
	r.title,
	r.category,
	r.description,
	coalesce (jsonb_agg(jsonb_build_object(
		'id', i.id,
		'title', i.title,
		'category', i.category,
		'price', i.price
	)) filter (where i.id is not null), '[]') as ingredients
from recipes r
left join ingredients_recipes ir on r.id = ir.recipe_id
left join ingredients i on i.id = ir.ingredient_id
group by r.id;

drop table if exists ingredients, recipes, ingredients_recipes cascade;
