drop table if exists article, coment;

create table article
(
	id int primary key,
	title text,
	date_public date,
	text text
);

create table coment
(
	article_id int references article,
	text text,
	date_public date
);

insert into article (id, title, date_public, text)
values
(1, 'статья 1', '2023.11.11', 'тут что то написано'),
(2, 'статья 2', '2022.01.17', 'тут что то написано'),
(3, 'статья 3', '2021.09.28', 'тут что то написано'),
(4, 'статья 4', '2021.09.18', 'тут что то написано');

insert into coment (article_id, text, date_public)
values
(1, 'Мои глаза ААА!', '2023.11.12'),
(2, 'Лучшее что я читал', '2022.02.01'),
(3, 'Что это?', '2021.10.11'),
(1, 'Hello wordl', '2023.12.11');

select
	id,
	title,
	a.date_public,
	a.text,
	coalesce (json_agg(json_build_object(
	'text', c.text, 'date_public', c.date_public))
		filter (where c.article_id is not null), '[]') as coment
from article a
left join coment c on a.id = c.article_id
group by a.id;