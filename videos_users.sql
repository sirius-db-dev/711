drop table if exists videos, users, videos_to_users cascade;

create table videos
(
	id int primary key,
	title_videos text,
	date_publication date,
	time_videos int
);

create table users 
(
	id int primary key,
	nickname text,
	date_registration date
);

create table videos_to_users
(
	videos_id int references videos,
	users_id int references users,
	primary key(videos_id, users_id)
);

insert into videos(id, title_videos, date_publication, time_videos)
values
(1, 'video1', '2022-12-23', 124),
(2, 'video2', '2019-03-29', 24),
(3, 'video3', '2023-09-23', 39);

insert into users(id, nickname, date_registration)
values
(1, 'User1', '2022-08-12'),
(2, 'User2', '2005-07-13'),
(3, 'User3', '2011-11-24'),
(4, 'User4', '2018-09-17');

insert into videos_to_users(videos_id, users_id)
values
	(1, 1),
	(1, 2),
	(2, 1),
	(2, 2),
	(2, 4),
	(3, 2),
	(3, 3);

select 
	vd.id,
	vd.title_videos,
	vd.date_publication,
	vd.time_videos,
	coalesce(jsonb_agg(json_build_object('id', us.id, 'nickname',
	us.nickname, 'date_registration', us.date_registration))
	filter(where us.id is not null), '[]') as users
from videos vd
left join videos_to_users vd_us on vd.id = vd_us.videos_id
left join users us on us.id = vd_us.videos_id
group by vd.id;

select 
	us.id,
	us.nickname,
	us.date_registration,
	coalesce(jsonb_agg(json_build_object('id', vd.id, 'title_videos', vd.title_videos, 'date_publication', vd.date_publication,
	'time_videos', vd.time_videos))
	filter(where vd.id is not null), '[]') as videos
from users us
left join videos_to_users vd_us on us.id = vd_us.users_id
left join videos vd on us.id = vd_us.videos_id
group by us.id;

	