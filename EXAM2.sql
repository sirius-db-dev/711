create extension if not exists "uuid-ossp";
drop table if exists aggregator, taxist, taxist_to_aggregator cascade;

create table aggregator (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);

create table taxist (
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	phone text,
	car text
);


create table taxist_to_aggregator (
	taxist_id uuid references taxist,
	aggregator_id uuid references aggregator,
	primary key (taxist_id, aggregator_id)
);


insert into taxist(first_name, last_name, phone, car) 
values
('Мария', 'Андрианова', '89753472566', 'Hundai');

insert into aggregator(title, phone) 
values
('Яндекс', '89139280866'),
('CityDrive', '+7(854) 376 25-88');

insert into taxist_to_aggregator(taxist_id, aggregator_id)
values
    ((select id from taxist where last_name = 'Андрианова'),
     (select id from aggregator where title = 'CityDrive'));


select
  a.id,
  a.first_name,
  a.last_name,
  a.phone,
  a.car,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone', f.phone))
      filter (where f.id is not null), '[]') as aggregator
from taxist a
left join taxist_to_aggregator af on a.id = af.taxist_id
left join aggregator f on f.id = af.aggregator_id
group by a.id;

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first_name', f.first_name, 'last_name', f.last_name, 'phone', f.phone, 'car', f.car))
      filter (where f.id is not null), '[]') as taxist
from aggregator a
left join taxist_to_aggregator af on a.id = af.aggregator_id
left join taxist f on f.id = af.taxist_id
group by a.id;



drop table if exists games, buyers, games_to_buyers cascade;

CREATE TABLE games (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	title text,
	genre text,
	price float
);

CREATE TABLE buyers (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	nickname text,
	registration_date date

);

create table games_to_buyers (
	buyers_id uuid references buyers,
	games_id uuid references games,
	primary key (buyers_id, games_id)
);

insert into games(title, genre, price) 
values
('Ведьмак', 'Fantasy', 470.99),
('Фортнайт', 'боевик', 890.99);


insert into buyers(nickname, registration_date) 
values
('Ведьма', '2023-03-09'),
('Самурай','2020-07-11');

insert into games_to_buyers(games_id, buyers_id)
values
    ((select id from games where title = 'Ведьмак'),
     (select id from buyers where nickname = 'Ведьма')),
    ((select id from games where title = 'Фортнайт'),
     (select id from buyers where nickname = 'Самурай'));


select
  a.id,
  a.title,
  a.genre,
  a.price,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'nickname', f.nickname, 'registration_date', f.registration_date))
      filter (where f.id is not null), '[]') as buyers
from games a
left join games_to_buyers af on a.id = af.games_id
left join buyers f on f.id = af.buyers_id
group by a.id;

select
  a.id,
  a.nickname,
  a.registration_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'genre', f.genre, 'price', f.price))
      filter (where f.id is not null), '[]') as games
from buyers a
left join games_to_buyers af on a.id = af.buyers_id
left join games f on f.id = af.games_id
group by a.id;


drop table if exists producer, product, product_to_producer cascade;

create table producer (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);

create table product (
	id uuid primary key default uuid_generate_v4(),
	title text,
	price float,
	category text
);


create table product_to_producer (
	product_id uuid references product,
	producer_id uuid references producer,
	primary key (product_id, producer_id)
);


insert into producer(title, phone) 
values
('Яндекс', '+79854734927'),
('Магнит', '89645839023');

insert into product(title, price, category) 
values
('Milk', 84.0, 'dairy_goods'),
('Орео', 50.0, 'cookies');

insert into product_to_producer(product_id, producer_id)
values
    ((select id from product where title = 'Milk'),
     (select id from producer where title = 'Яндекс')),
    ((select id from product where title = 'Орео'),
     (select id from producer where title = 'Магнит'));

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'price', f.price, 'category', f.category))
      filter (where f.id is not null), '[]') as product
from producer a
left join product_to_producer af on a.id = af.product_id
left join product f on f.id = af.product_id
group by a.id;

select
	a.id,
	a.title,
	a.price,
	a.category,
	coalesce(jsonb_agg(jsonb_build_object(
	    'id', f.id, 'title', f.title, 'phone', f.phone))
	      filter (where f.id is not null), '[]') as producer
from product a
left join product_to_producer af on a.id = af.product_id
left join producer f on f.id = af.producer_id
group by a.id;
	      
	

