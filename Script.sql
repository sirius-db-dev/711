-- Игры и покупатели:
-- у игры может быть много покупателей
-- у покупателя может быть много игр
-- игра - название, жанр, цена
-- покупатель - никнейм, дата регистрации
--  в качестве id нужно использовать uuid
-- связанная сущность должна быть представлена в виде массива объектов
-- учесть случай когда на строки в левой таблице может не быть ссылок

drop table if exists game, buyer;
drop table if exists teacher, study_build;
drop table if exists fest, people_fest;

create table game (
	id uuid,
	name_ text,
	genre text,
	price int
);

insert into game (name_, genre, price)
values
('Монополия', 'азарт', 300),
('Uno', 'азарт', 250),
('3 двери', 'логика', 500);

select * from game;

create table buyer (
	id uuid,
	n_name text,
	date_ date
);

insert into buyer (n_name, date_)
values
('wer', '2022.12.03'),
('lkjio23', '2023.01.02'),
('pop', '2021.02.24');

select * from buyer;

select
	g_id as game_id,
	name_,
	genre,
	price,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', b.id, 'n_name', n_name, 'date_', date_))
			filter (where b.id is not null), '[]') as buyer

from game g
left join buyer b on g.id = b.game_id
group by g.id;

select
	b_id as byuer_id,
	n_name,
	date_,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', g.id, 'name_', name_, 'genre', genre, 'price', price))
			filter (where g.id is not null), '[]') as game

from buyer b
left join game g on b.id = g.buyer_id
group by b.id;


-- Преподаватели и учебные заведения
-- преподаватель может работать в нескольких учебных заведений
-- в учебном заведении может работать несколько преподавателей
-- преподаватель - имя, фамилия, дата рождения, ученая степень, стаж
-- учебное заведение - название, адрес

create table teacher (
	id uuid,
	name_first text,
	name_last text,
	date_bd date,
	experienc text,
	professional int
);

insert into teacher (name_first, name_last, date_bd, experienc, professional)
values
('Иванов', 'Иван', '1989.01.01', 'высшая', 3),
('Петров', 'Пётр', '1956.02.02', 'высшая', 25),
('Смирнов', 'Алексей', '1966.03.03', 'средняя', 12);

select * from teacher;

create table study_build (
	id uuid,
	name_study text,
	adress text
);

insert into study_build (name_study, adress)
values
('Сириус', 'Сириус, пр. Олимпийский 1'),
('СПБГУ', 'Санкт-Петербург, ул Маяковского 13'),
('НИУ ВШЭ', 'Москва, ул Ленина 42');

select * from study_build;

select
	t_id as teacher_id,
	name_first,
	name_last,
	date_bd,
	experienc,
	professional,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', sb.id, 'name_study', name_study, 'adress', adress))
			filter (where sb.id is not null), '[]') as study_build

from teacher t
left join study_build sb on sb.id = sb.teacger_id
group by teacher.id;

select 
	sb_id as study_build,
	name_study,
	adress,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', t.id, 'name_first', name_first, 'name_last', name_last, 'date_bd', date_bd, 
		'experienc', experienc, 'professional', professional))
			filter (where t.id is not null), '[]') as teacher
			
from study_id sb
left join teacher t on t.id = t.study_id
group by study_build.id;

-- Фестивали и участники
-- в фестивале могут принимать участие несколько людей
-- человек может принимать участие в нескольких фестивалях
-- фестиваль - название, дата, место
-- человек - имя, фамилия, дата рождения

create table fest (
	id uuid,
	name_ text,
	date_f date,
	place text
);

insert into fest (name_, date_f, place)
values
('ВФМ', '2024.03.02', 'Сириус'),
('Молодёжь-2023', '2023.07.14', 'Москва'),
('Умы-России', '2023.09.02', 'Санкт-Петербург');

select * from fest;

create table people_fest (
	id uuid,
	name_first text,
	name_last text,
	date_bd date
);

insert into people_fest (name_first, name_last, date_bd)
values
('Александр', 'Иванов', '1979.05.12'),
('Сергей', 'Алексеев', '1989.04.12'),
('Виктория', 'Борисова', '1991.01.01');

select * from people_fest;

select
	f_id as fest_id,
	name_,
	date_f,
	date_bd,
	place,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', pf.id, 'name_first', name_first, 'name_last', name_last))
			filter (where pf.id is not null), '[]') as people_fest

from fest f
left join people_fest pf on pf.id = pf.fest_id
group by fest.id;


select 
	pf_id as people_fest_id,
	name_first,
	name_last,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', f.id, 'name_', name_, 'date_f', date_f, 'date_bd', date_bd, 'place', place))
			filter (where f.id is not null), '[]') as fest
			
from people_fest pf
left join fest f on f.id = f.people_fest.id
group by people_fest.id;











