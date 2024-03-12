/*
1. Чаты и сообщения:
чат может иметь несколько сообщений
сообщение может принадлежать только одному чату
чат - название, дата создания
сообщение - текст, дата отправки
*/


drop table if exists chats, messages cascade;

create table chats
(
	id int primary key,
	name text,
	creation_date date
);

create table messages
(
	id int primary key,
	chat_id int references chats(id),
	content text,
	dispatch_date date
);

insert into chats(id, name, creation_date)
values
(1, 'Реальные пацаны', '2023.10.23'),
(2, 'Высшмат К0711-23', '2023.09.15'),
(3, 'programmers dangeon', '2023.11.05'),
(4, 'Пустой чат', '2024.02.11');

insert into messages(id, chat_id, content, dispatch_date)
values
(1, 3, 'Привет', '2024.01.23'),
(2, 3, 'Как дела?', '2024.01.24'),
(3, 1, 'Спроси у Дена, он всё знает', '2023.11.05'),
(4, 1, 'Я не знаю', '2023.11.05'),
(5, 2, 'Ребята, отправляю СРС на следующий семинар', '2024.01.01'),
(6, 3, 'Срочная информация!', '2024.02.16'),
(7, 2, '<ссылка_на_тик_ток_с_мемом_про_мишу>', '2024.02.16');

select
	chats.id,
	name,
	creation_date,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', messages.id,
		'content', messages.content,
		'dispatch_date', messages.dispatch_date))
			filter (where messages.id is not null), '[]') as messages
from chats
left join messages on chats.id = messages.chat_id
group by chats.id
order by chats.id asc;
