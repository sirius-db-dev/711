create extension if not exists "uuid-ossp";

drop table if exists users, video, user_to_video cascade;


create table users
(
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	date_of_registration date	
);

create table video
(
	id uuid primary key default uuid_generate_v4(),
	video_name text,
	date_publish date
);

create table user_to_video
(
	user_id uuid references users not null,
	video_id uuid references video not null,
	unique(user_id, video_id)
);

insert into users (nickname, date_of_registration)
values
('user', '2021.05.11'),
('admin', '2012.06.09'),
('sirius', '2024.01.01');

insert into video (video_name, date_publish)
values
('Видео 1', '2020.06.11'),
('Видео 2', '2019.07.11'),
('Видео 3', '2018.08.11');

insert into user_to_video (user_id, video_id)
values
((select id from users where nickname = 'user'), (select id from video where video_name = 'Видео 1')),
((select id from users where nickname = 'user'), (select id from video where video_name = 'Видео 2')),
((select id from users where nickname = 'admin'), (select id from video where video_name = 'Видео 1')),
((select id from users where nickname = 'admin'), (select id from video where video_name = 'Видео 3')),
((select id from users where nickname = 'sirius'), (select id from video where video_name = 'Видео 2')),
((select id from users where nickname = 'sirius'), (select id from video where video_name = 'Видео 3'));

select
	v.id,
	v.video_name,
	v.date_publish,
	coalesce(jsonb_agg(json_build_object(
		'id', u.id, 'nickname', u.nickname, 'date_of_registration', u.date_of_registration))
		filter (where u.id is not null), '[]') as users
from video v
left join user_to_video uv on v.id = uv.video_id
left join users u on u.id = uv.user_id
group by v.id
order by v.id;

select
	u.id,
	u.nickname,
	u.date_of_registration,
	coalesce(jsonb_agg(json_build_object(
		'id', v.id, 'video_name', v.video_name, 'date_publish', v.date_publish))
		filter (where v.id is not null), '[]') as video
from users u
left join user_to_video uv on u.id = uv.user_id
left join video v on v.id = uv.video_id
group by u.id
order by u.id;