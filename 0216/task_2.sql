/*
2. Курсы и отзывы:
курс может иметь несколько отзывов
отзыв может принадлежать только одному курсу
курс - название, описание
отзыв - текст, оценка
*/


drop table if exists courses, reviews cascade;

create table courses
(
	id int primary key,
	name text,
	description text
);

create table reviews
(
	id int primary key,
	course_id int references courses(id),
	content text,
	rating int
);

insert into courses(id, name, description)
values
(1, 'Открываем свой бизнес', 'Бизнес/Предпринимательство'),
(2, 'ЕГЭ Проф. мат. Трушин', 'ЕГЭ'),
(3, 'Курс без отзывов', 'Как создать самый популярный курс?');

insert into reviews(id, course_id, content, rating)
values
(1, 2, 'Курс топ!', 5),
(2, 1, 'Верните деньги!', 1),
(3, 2, 'Сдал на 97! Спасибо!!!', 5),
(4, 1, 'Дорого. Дайте скидку', 3);

select
	courses.id,
	name,
	description,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', reviews.id,
		'content', reviews.content,
		'rating', reviews.rating))
			filter (where reviews.id is not null), '[]') as reviews
from courses
left join reviews on courses.id = reviews.course_id
group by courses.id
order by courses.id asc;
