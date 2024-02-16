drop table if exists recipies, to_comments cascade;

create table recipies
(
	id int primary key,
	title_recipies text,
	discription_recipies text,
	category text
);

create table to_comments
(	
	id int,
	recipies_id int references recipies,
	content text,
	date_of_publishing date
);

insert into recipies(id, title_recipies, discription_recipies, category)
values
(1, 'Vanil cake', 'Airy sponge cake', 'Desert'),
(2, 'Steak', 'Medium rare steak', 'Beef'),
(3, 'Vegetable soup', 'Easy homemade soup', 'Soup');

insert into to_comments(id, recipies_id, content, date_of_publishing)
values
(1, 1, 'That very delishes', '2010-05-23'),
(2, 3, 'Perfect', '2016-11-14'),
(3, 2, 'Thank you', '2018-04-15'),
(4, 2, 'I am late a more recepies', '2018-05-19');

select 
	rp.id,
	rp.title_recipies,
	rp.discription_recipies,
	rp.category, 
	coalesce(json_agg(jsonb_build_object('id', tc.id, 'content', tc.content, 
	'date_of_publishing', tc.date_of_publishing))
	filter(where tc.id is not null), '[]') as to_comments
from recipies rp
left join to_comments tc on rp.id = tc.recipies_id
group by rp.id;