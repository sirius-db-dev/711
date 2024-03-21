create extension if not exists "uuid-ossp";
drop table if exists delivery, courier, courier_to_delivery cascade;

create table courier (
	id uuid primary key default uuid_generate_v4(),
	name text,
	last_name text,
	phone text,
	vehicle text,
	bag_size float 
);

create table delivery (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);


create table courier_to_delivery (
	courier_id uuid references courier,
	delivery_id uuid references delivery,
	primary key (courier_id, delivery_id)
);


insert into courier(name, last_name, phone, vehicle, bag_size) 
values
('Артем', 'Пименов', '89813854032', 'велик', 5.1),
('Элеонора', 'Карпова', '89113852713', 'самокат', 2.4),
('Дима', 'Мартьянов',  '89761235468', 'такси', 8.9);

insert into delivery(title, phone) 
values
('Ролы', '+89139280848'),
('Лапша', '+7(842) 376 24-73'),
('Бургеры', '+7(854) 376 25-43');

insert into courier_to_delivery(courier_id, delivery_id)
values
    ((select id from courier where last_name = 'Пименов'),
     (select id from delivery where title = 'Лапша')),
    ((select id from courier where last_name = 'Пименов'),
     (select id from delivery where title = 'Бургеры')),
    ((select id from courier where last_name = 'Карпова'),
     (select id from delivery where title = 'Ролы')),
    ((select id from courier where last_name = 'Мартьянов'),
     (select id from delivery where title = 'Лапша'));


select
  a.id,
  a.name,
  a.last_name,
  a.phone,
  a.vehicle,
  a.bag_size,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone number', f.phone))
      filter (where f.id is not null), '[]') as delivery
from courier a
left join courier_to_delivery af on a.id = af.courier_id
left join delivery f on f.id = af.delivery_id
group by a.id;

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first name', f.name, 'last name', f.last_name, 'phone number', f.phone, 'vehicle', f.vehicle, 'bag size', f.bag_size))
      filter (where f.id is not null), '[]') as courier
from delivery a
left join courier_to_delivery af on a.id = af.delivery_id
left join courier f on f.id = af.courier_id
group by a.id;



drop table if exists musical_compositions, musicians, musicians_to_musical_compositions cascade;

CREATE TABLE musical_compositions (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	title text,
	genre text,
	music_length float
);

CREATE TABLE musicians (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	first_name text,
	second_name text,
	birth_year date

);

create table musicians_to_musical_compositions (
	musicians_id uuid references musicians,
	musical_compositions_id uuid references musical_compositions,
	primary key (musicians_id, musical_compositions_id)
);

insert into musical_compositions(title, genre, music_length) 
values
('Лебединое озеро', 'классика', 2.35),
('Танец феи драже', 'классика', 4.10);


insert into musicians(first_name, second_name, birth_year) 
values
('Марк', 'Рейнски', '2000-03-06'),
('Элеонора', 'Карпова', '2003-07-09');

insert into musicians_to_musical_compositions(musicians_id, musical_compositions_id)
values
    ((select id from musicians where second_name = 'Рейнски'),
     (select id from musical_compositions where title = 'Лебединое озеро')),
    ((select id from musicians where second_name = 'Карпова'),
     (select id from musical_compositions where title = 'Танец феи драже'));


select
  a.id,
  a.first_name,
  a.second_name,
  a.birth_year,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'genre', f.genre, 'music_length', f.music_length))
      filter (where f.id is not null), '[]') as musical_compositions
from musicians a
left join musicians_to_musical_compositions af on a.id = af.musicians_id
left join musical_compositions f on f.id = af.musical_compositions_id
group by a.id;

select
  a.id,
  a.title,
  a.genre,
  a.music_length,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first_name', f.first_name, 'second_name', f.second_name, 'birth_year', f.birth_year))
      filter (where f.id is not null), '[]') as musicians
from musical_compositions a
left join musicians_to_musical_compositions af on a.id = af.musical_compositions_id
left join musicians f on f.id = af.musicians_id
group by a.id;


drop table if exists producer, shop, producer_to_shop cascade;

create table producer (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);

create table shop (
	id uuid primary key default uuid_generate_v4(),
	title text,
	street_address text
);


create table producer_to_shop (
	producer_id uuid references shop,
	shop_id uuid references producer,
	primary key (producer_id, shop_id)
);


insert into producer(title, phone) 
values
('Любятово', '+79854734927'),
('Орео', '89645839023');

insert into shop(title, street_address) 
values
('Пятерочка', 'Отличников, 1'),
('Магнит', 'Металлическая, 12');

insert into producer_to_shop(producer_id, shop_id)
values
    ((select id from shop where title = 'Магнит'),
     (select id from producer where title = 'Любятово')),
    ((select id from shop where title = 'Пятерочка'),
     (select id from producer where title = 'Орео'));

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'street_address', f.street_address))
      filter (where f.id is not null), '[]') as shop
from producer a
left join producer_to_shop af on a.id = af.producer_id
left join shop f on f.id = af.shop_id
group by a.id;

select
  a.id,
  a.title,
  a.street_address,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone', f.phone))
      filter (where f.id is not null), '[]') as producer
from shop a
left join producer_to_shop af on a.id = af.shop_id
left join producer f on f.id = af.producer_id
group by a.id; 









































create extension if not exists "uuid-ossp";
drop table if exists delivery, courier;

create table courier (
	id uuid primary key default uuid_generate_v4(),
	name text,
	last_name text,
	phone text,
	vehicle text,
	bag_size float 
);

create table delivery (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);


create table courier_to_delivery (
	courier_id uuid references courier,
	delivery_id uuid references delivery,
	primary key (courier_id, delivery_id)
);


insert into courier(name, last_name, phone, vehicle, bag_size) 
values
('Артем', 'Пименов', '89813854032', 'велик', 5.1),
('Элеонора', 'Карпова', '89113852713', 'самокат', 2.4),
('Дима', 'Мартьянов',  '89761235468', 'такси', 8.9);

insert into delivery(title, phone) 
values
('Ролы', '+89139280848'),
('Лапша', '+7(842) 376 24-73'),
('Бургеры', '+7(854) 376 25-43');

insert into courier_to_delivery(courier_id, delivery_id)
values
    ((select id from courier where last_name = 'Пименов'),
     (select id from delivery where title = 'Лапша')),
    ((select id from courier where last_name = 'Пименов'),
     (select id from delivery where title = 'Бургеры')),
    ((select id from courier where last_name = 'Карпова'),
     (select id from delivery where title = 'Ролы')),
    ((select id from courier where last_name = 'Мартьянов'),
     (select id from delivery where title = 'Лапша'));
    

select
  a.id,
  a.name,
  a.last_name,
  a.phone,
  a.vehicle,
  a.bag_size,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone number', f.phone))
      filter (where f.id is not null), '[]') as delivery
from courier a
left join courier_to_delivery af on a.id = af.courier_id
left join delivery f on f.id = af.delivery_id
group by a.id;

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first name', f.name, 'last name', f.last_name, 'phone number', f.phone, 'vehicle', f.vehicle, 'bag size', f.bag_size))
      filter (where f.id is not null), '[]') as courier
from delivery a
left join courier_to_delivery af on a.id = af.delivery_id
left join courier f on f.id = af.courier_id
group by a.id;
  73 changes: 73 additions & 0 deletions 73  
test-2.SQL
 
@@ -0,0 +1,73 @@
create extension if not exists "uuid-ossp";
drop table if exists musical_compositions, musicians;

CREATE TABLE musical_compositions (
	id uuid PRIMARY KEY DEFAULT uiid_generate_v4(),
	title text;
	genre text;
	music_length float
);

CREATE TABLE musicians (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	first_name text,
	second_name text,
	birth_year date
	
);

create table musicians_to_musical_compositions (
	musicians_id uuid references musicians,
	musical_compositions_id uuid references musical_compositions,
	primary key (musicians_id, musical_compositions_id)
);

insert into musical_compositions(title, genre, music_lenth) 
values
('Лебединое озеро', 'классика', 2.35),
('Танец феи драже', 'классика', 4.10);


insert into musicians(first_name, second_name, birth_year) 
values
('Марк', 'Рейнски', '2000-03-06'),
('Элеонора', 'Карпова', '2003-07-09');

insert into musicians_to_musical_compositions(musicians_id, musical_compositions_id)
values
    ((select id from musicians where last_name = 'Рейнски'),
     (select id from musical_compositions where title = 'Лебединое озеро')),
    ((select id from musicians where last_name = 'Карпова'),
     (select id from musical_compositions where title = 'Танец феи драже'));
    

select
  a.id,
  a.first_name,
  a.second_name,
  a.birth_year,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first_name', f.first_name, 'second_name', f.second_name, 'birth_year', f.birth_year))
      filter (where f.id is not null), '[]') as musical_compositions
from musicians a
left join musicians_to_musical_compositions af on a.id = af.musicians_id
left join musical_compositions f on f.id = af.musical_compositions_id
group by a.id;

select
  a.id,
  a.title,
  a.genre,
  a.music_length,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.titlw, 'genre', f.genre, 'music_length', f.music_length))
      filter (where f.id is not null), '[]') as musicians
from musicians a
left join musicians_to_musical_compositions af on a.id = af.musicians_id
left join musical_compositions f on f.id = af.musical_compositions_id
group by a.id;
  73 changes: 73 additions & 0 deletions 73  
test-2.SQL

 
@@ -0,0 +1,71 @@
create extension if not exists "uuid-ossp";
drop table if exists producer, shop;

create table producer (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text,
);

create table shop (
	id uuid primary key default uuid_generate_v4(),
	title text,
	street_address text,
);


create table producer_to_shop (
	producer_id uuid references shop,
	shop_id uuid references producer,
	primary key (producer_id, shop_id)
);


insert into producer(title, phone) 
values
('Любятово', '+79854734927'),
('Орео', '89645839023');

insert into shop(title, street_address) 
values
('Пятерочка', 'Отличников, 1'),
('Магнит', 'Металлическая, 12');

insert into producer_to_shop(producer_id, shop_id)
values
    ((select id from producer where title = 'Любятово'),
     (select id from shop where title = 'Магнит')),
    ((select id from producer where title = 'Орео'),
     (select id from shop where title = 'Пятерочка'));

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone', f.phone))
      filter (where f.id is not null), '[]') as shop
from producer a
left join producer_to_shop af on a.id = af.producer_id
left join shop f on f.id = af.shop_id
group by a.id;

select
  a.id,
  a.title,
  a.street_address,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'street_address', f.street_address))
      filter (where f.id is not null), '[]') as producer
from shop a
left join producer_to_shop af on a.id = af.shop_id
left join producer f on f.id = af.producer_id
group by a.id;