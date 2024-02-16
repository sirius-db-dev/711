--1

drop table if exists books, reviews;

create table books
(
	id int primary key,
	title text,
	genre text,
	publication_year int
);

create table reviews
(	
	id int primary key,
	book_id int,
	texts text,
	rate int
);

insert into books(id, title, genre, publication_year)
values
(1, 'Book1', 'drama', 2005),
(2, 'Book2', 'comedy', 2010),
(3, 'Book3', 'detective', 2020);

insert into reviews(id, book_id, texts, rate)
values
(1, 1, 'some words', 5),
(2, 1, 'very bad', 2),
(3, 2, 'very good', 4);

select * from books

select
	title,
	genre,
	coalesce(json_agg(json_build_object(
		'texts', reviews.texts, 'rate', reviews.rate))
		 filter (where reviews.id is not null), '[]') as reviews
from books
	left join reviews on books.id = reviews.book_id
group by books.id


--2

drop table if exists games, reviews_games;

create table games
(
	id int primary key,
	title text,
	genre text,
	price int
);

create table reviews_games
(	
	id int primary key,
	game_id int,
	texts text,
	rate int
);

insert into games(id, title, genre, price)
values
(1, 'Game1', 'shooter', 1000),
(2, 'Game2', 'strategy', 500),
(3, 'Game3', 'puzzle', 130);

insert into reviews_games(id, game_id, texts, rate)
values
(1, 1, 'some words', 5),
(2, 1, 'very bad', 2),
(3, 2, 'very good', 4);


select
	title,
	genre,
	coalesce(json_agg(json_build_object(
		'texts', reviews_games.texts, 'rate', reviews_games.rate))
		 filter (where reviews_games.id is not null), '[]') as reviews_ganes
from games
	left join reviews_games on games.id = reviews_games.game_id
group by games.id


--3

drop table if exists couriers, orders;

create table couriers
(
	id int primary key,
	first_name text,
	last_name text,
	phone_number text
);


create table orders
(
	id int primary key,
	courier_id int,
	data text,
	status text
);

insert into couriers(id, first_name, last_name, phone_number)
values
	(1, 'Vanya', 'Ivanov', '88005553535'),
	(2, 'Petya', 'Petrov', '89617733455');


insert into orders(id, courier_id, data, status)
values
	(1, 1, '09.02.2024', 'ожидается'),
	(2, 1, '08.02.2024', 'доставлен'),
	(3, 2, '09.02.2024', 'ожидается');


select
	first_name,
	last_name,
	coalesce(json_agg(json_build_object(
		'data', orders.data, 'status', orders.status))
		 filter (where orders.id is not null), '[]') as orders
from couriers
	left join orders on couriers.id = orders.courier_id
group by couriers.id
	

