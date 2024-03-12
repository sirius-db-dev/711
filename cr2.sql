--1

create extension if not exists "uuid-ossp";

drop table if exists event, partician, event_partician cascade;

create table event
(
    id uuid primary key default uuid_generate_v4(),
    event_name text,
    date date,
    place text
);

create table partician (
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	birth_date date
);

create table event_partician
(
    event_id uuid references event,
    partician_id  uuid references partician,
    primary key (event_id, partician_id)
);

insert into event(event_name, date, place)
values ('ВФМ', '2024-03-01', 'Сириус'),
('пара по программированию', '2024-03-03', 'колледж'),
('A', '2024-01-01', 'B');


insert into partician(first_name, last_name, birth_date)
values ('Иван', 'Иванов', '1996-06-01'),
('Пётр', 'Петров', '2000-03-04'),
('Биба', 'А', '2007-01-01');


insert into event_partician(event_id, partician_id)
values
    ((select id from event where event_name = 'ВФМ'),
    (select id from partician where last_name = 'Иванов')),
    ((select id from event where event_name = 'ВФМ'),
    (select id from partician where last_name = 'Петров')),
    ((select id from event where event_name = 'пара по программированию'),
    (select id from partician where last_name = 'А')),
    ((select id from event where event_name = 'ВФМ'),
    (select id from partician where last_name = 'А'));
    
       
     

select
  p.id,
  p.first_name,
  p.last_name,
  p.birth_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', e.id, 'title', e.event_name, 'imdb_rating', e.place))
      filter (where e.id is not null), '[]') as event
from partician p
left join event_partician ep on p.id = ep.partician_id
left join event e on e.id = ep.event_id
group by p.id;


--2

drop table if exists delivery, courier, delivery_courier cascade;

create table delivery
(
    id         uuid primary key default uuid_generate_v4(),
    title text,
    phone  text
);

create table courier
(
    id          uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
    phone text,
    vechicle text,
    bag int
);

create table delivery_courier
(
    del_id uuid references delivery,
    courier_id  uuid references courier,
    primary key (del_id, courier_id)
);

insert into courier(first_name, last_name, phone, vechicle, bag)
values ('Биба', 'Бибович', '88005553535', 'мотоцикл', '12'),
('Боба', 'Бобович', '8080880882', 'машина', '20'),
('A', 'A', '0000000000', 'ноги', '10');

insert into delivery(title, phone)
values ('обед', '0000000030'),
('завтрак', '12345678910'),
('ужин', '23412312312');


insert into delivery_courier(del_id, courier_id)
values
    ((select id from delivery where title = 'обед'),
     (select id from courier where last_name = 'Бибович')),
    ((select id from delivery where title = 'обед'),
     (select id from courier where last_name = 'Бобович')),
    ((select id from delivery where title = 'завтрак'),
     (select id from courier where last_name = 'Бибович')),
    ((select id from delivery where title = 'завтрак'),
     (select id from courier where last_name = 'A')),
    ((select id from delivery where title = 'ужин'),
     (select id from courier where last_name = 'A'));

select
  c.id,
  c.first_name,
  c.last_name,
  c.phone,
  c.vechicle,
  c.bag,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', d.id, 'title', d.title, 'phone', d.phone))
      filter (where d.id is not null), '[]') as delivs
from courier c
left join delivery_courier dc on c.id = dc.courier_id
left join delivery d on d.id = dc.del_id
group by c.id;




--3

drop table if exists book, author, book_to_author cascade;

create table book
(
    id         uuid primary key default uuid_generate_v4(),
    title text,
    genre  text,
    year int
);

create table author
(
    id          uuid primary key default uuid_generate_v4(),
    first_name  text,
    last_name text,
    birth_year int
);

create table book_to_author
(
    book_id uuid references book,
    author_id  uuid references author,
    primary key (book_id, author_id)
);

insert into book(title, genre, year)
values ('A', 'B', 2004),
('B', 'S', 2017),
('C', 'C', 2022);

insert into author(first_name, last_name, birth_year)
values ('A', 'A', 2000),
('B', 'B', 1984),
('C', 'C', 1999);



insert into book_to_author(book_id, author_id)
values
    ((select id from book where title = 'A'),
     (select id from author where last_name = 'A')),
    ((select id from book where title = 'B'),
     (select id from author where last_name = 'A')),
    ((select id from book where title = 'A'),
     (select id from author where last_name = 'C')),
    ((select id from book where title = 'C'),
     (select id from author where last_name = 'B'));


select
  a.id,
  a.first_name,
  a.last_name,
  a.birth_year,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', b.id, 'title', b.title, 'year', b.year))
      filter (where b.id is not null), '[]') as book
from author a
left join book_to_author ba on a.id = ba.author_id
left join book b on b.id = ba.book_id
group by a.id;





