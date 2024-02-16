drop table if exists chats, messages cascade;

create table chats
(
	id int primary key,
	name text,
	date_create date
);

create table messages
(
	id int primary key,
	chat_id int references chats,
	text_message text,
	date_send date
);

insert into chats (id, name, date_create)
values
(1, 'K0711-23', '2023.09.01'),
(2, 'K0711-22', '2023.08.02'),
(3, 'K0711-21', '2023.07.03'),
(4, 'K0711-20', '2023.08.02');

insert into messages (id, chat_id, text_message, date_send)
values
(1, 1, 'Завтра 6 пар', '2023.10.01'),
(2, 1, 'Это плохая новость', '2023.10.01'),
(3, 2, 'Завтра 3 пары', '2023.10.01'),
(4, 2, 'Это хорошая новость', '2023.10.01'),
(5, 3, 'Завтра 0 пар', '2023.10.01'),
(6, 3, 'Это отличная новость', '2023.10.01');

select
	c.id,
	c.name,
	c.date_create,
	coalesce(jsonb_agg(json_build_object(
		'id', m.id, 'text_message', m.text_message, 'date_send', m.date_send))
			filter (where m.id is not null), '[]') as messages
from chats c
left join messages m on c.id = m.chat_id
group by c.id
order by c.id;