drop table if exists recipes_, comments_;

create table recipes_
(
	id int primary key,
	name_ text,
	description text,
	category_ text
);

create table comments_
(
	id int primary key,
	recipe_id int references recipes_,
	data_ text,
	pub_date date
);

insert into recipes_ (id, name_, description, category_)
values
(1, 'pancake', 'yummy', 'snacks'),
(2, 'borsh', 'goated', 'soups');


insert into comments_ (id, recipe_id, data_, pub_date)
values
(1, 2, 'nononon', '2019.05.05'),
(2, 2, 'kkkkkkk', '2022.03.03'),
(3, 1, 'fhkjs', '2012.03.03'),
(4, 1, 'Sochi', '2056.03.03');

select
	rp.id,
	rp.name_,
	rp.description,
	rp.category_,
	coalesce(
		json_agg(
			json_build_object(
				'recipe_id', cm.recipe_id,
				'comment_id', cm.id,
				'data', cm.data_,
				'pub_date', cm.pub_date
				)
			) filter (where cm.id is not null),
		'[]'
		)
		as city
from recipes_ rp
left join comments_ cm on rp.id = cm.recipe_id
group by rp.id;