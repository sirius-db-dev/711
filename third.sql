create extension if not exists "uuid-ossp";

drop table if exists providers, products, providers_products cascade;

create table if not exists providers (
	id uuid primary key default uuid_generate_v4(),
	title varchar(128) not null,
	phone_number varchar(16) not null
);

create table if not exists products (
	id uuid primary key default uuid_generate_v4(),
	title varchar(128) not null,
	category varchar(128) not null default 'food',
	price decimal not null default 100
);

create table if not exists providers_products (
	provider_id uuid,
	product_id uuid,

	primary key (provider_id, product_id)
);


insert into providers (title, phone_number)
values
	('prv_first', '79222222222'),
	('prv_second', '79222222222'),
	('prv_third', '79222222222');

insert into products (title)
values
	('prd_first'),
	('prd_second'),
	('prd_third');


insert into providers_products (provider_id, product_id)
values
	((select id from providers where title = 'prv_first'), (select id from products where title = 'prd_first')),
	((select id from providers where title = 'prv_first'), (select id from products where title = 'prd_second')),
	((select id from providers where title = 'prv_second'), (select id from products where title = 'prd_third'));


select
	prv.id,
	prv.title,
	prv.phone_number,
	coalesce (jsonb_agg(jsonb_build_object(
		'id', prd.id,
		'title', prd.title,
		'category', prd.category,
		'price', prd.price
	)) filter (where prd.id is not null), '[]') as products
from providers prv
left join providers_products pp on prv.id = pp.provider_id
left join products prd on prd.id = pp.product_id
group by prv.id;


select
	prd.id,
	prd.title,
	prd.category,
	prd.price,
	coalesce (jsonb_agg(jsonb_build_object(
		'id', prv.id,
		'title', prv.title,
		'phone_number', prv.phone_number
	)) filter (where prv.id is not null), '[]') as providers
from products prd
left join providers_products pp on prd.id = pp.product_id
left join providers prv on prv.id = pp.provider_id
group by prd.id;


drop table if exists providers, products, providers_products cascade;
