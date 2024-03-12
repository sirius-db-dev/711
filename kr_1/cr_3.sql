drop table if exists perfomans, festivals;

create table festivals
(
	id int primary key,
	title text,
	date date,
	place text
);

create table perfomans
(
	festival_id int references festivals,
	title text,
	date date,
	genre text
);

insert into festivals (id, title, date, place)
values
(1, 'фестиваль 1', '2024.01.09', 'тут что то написано'),
(2, 'фестиваль 2', '2024.01.19', 'тут что то написано'),
(3, 'фестиваль 3', '2024.11.29', 'тут что то написано'),
(4, 'фестиваль 4', '2024.02.09', 'тут что то написано');

insert into perfomans (festival_id, title, date, genre)
values
(1, '', '2024.01.09', 'драма'),
(2, '', '2024.01.19', 'драма'),
(3, '', '2024.11.29', 'драма'),
(1, '', '2024.01.09', 'драма');

select 
	id,
	f.title,
	f.date,
	place,
	coalesce (json_agg(json_build_object(
	'title', p.title, 'date', p.date, 'genre', p.genre))
		filter (where p.title is not null), '[]') as perfomans
from festivals f
left join perfomans p on f.id = p.festival_id
group by f.id;