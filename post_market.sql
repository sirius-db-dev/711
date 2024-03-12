drop table if exists post, market, post_to_market cascade;

create table post
(
	id int primary key,
	title_post text,
	phone text
);

create table market
(
	id int primary key,
	title_market text,
	address text
);

create table post_to_market
(
	post_id int references post,
	market_id int references market,
	primary key(post_id, market_id)
);

insert into post(id, title_post, phone)
values
(1, 'post1', '78929023059'),
(2, 'post2', '89238842882'),
(3, 'post3', '92939293923');

insert into market(id, title_market, address)
values
(1, 'market1', 'Street1'),
(2, 'market2', 'Street2'),
(3, 'market3', 'Street3'),
(4, 'market4', 'Street4');

insert into post_to_market(post_id, market_id)
values
	(1, 1),
	(1, 3),
	(1, 4),
	(2, 2),
	(2, 3),
	(3, 1),
	(3, 4);

select 
	pst.id,
	pst.title_post,
	pst.phone,
	coalesce(jsonb_agg(json_build_object('id', mk.id, 'title_market',
	mk.title_market, 'address', mk.address))
	filter(where mk.id is not null), '[]') as market
from post pst
left join post_to_market pst_mk on pst.id = pst_mk.post_id
left join market mk on mk.id = pst_mk.post_id
group by pst.id;

select 
	mk.id,
	mk.title_market,
	mk.address,
	coalesce(jsonb_agg(json_build_object('id', pst.id, 'title_post', pst.title_post, 'phone', pst.phone))
	filter(where pst.id is not null), '[]') as post
from market mk
left join post_to_market pst_mk on mk.id = pst_mk.market_id
left join post pst on mk.id = pst_mk.post_id
group by mk.id;
