drop table if exists chat, message cascade;

create table chat(
id int primary key, 
name_chat varchar(30),
date_create date
);


create table message(
id int primary key, 
id_chat int references message,
text_message text,
date_send date
);

insert into chat(id, name_chat, date_create) values
(1, 'Brother', '01-02-2002'),
(2, 'Uncle', '04-07-2005'),
(3, 'Mum', '04-07-2005');

insert into message(id, id_chat, text_message, date_send) values
(1, 1, 'Hello', '02-02-2002'),
(2, 1, 'Hey', '03-04-2002'),
(3, 1, 'How are you?', '04-02-2002'),
(4, 2, 'Hello', '05-07-2005'),
(5, 2, 'Wassap', '05-07-2005');

select * from chat;
select * from message;

select chat.id, chat.name_chat, chat.date_create,
coalesce(json_agg(json_build_object(
'message_id', message.id, 'text_message', message.text_message, 'date_send', message.date_send))
filter(where message.id is not null), '[]') as message
from chat
left join message on chat.id = message.id_chat
group by chat.id;



