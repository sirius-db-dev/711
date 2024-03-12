create extension if not exists "uuid-ossp";

drop table if exists videos, users, videos_users cascade;

create table if not exists videos (
	id uuid primary key default uuid_generate_v4(),
	title varchar(128) not null,
	publication_date date not null default now(),
	duration float not null default 10 -- minutes
);

create table if not exists users (
	id uuid primary key default uuid_generate_v4(),
	nickname varchar(128) not null,
	registration_date date not null default now()
);

create table if not exists videos_users (
	video_id uuid,
	user_id uuid,

	primary key (video_id, user_id)
);


insert into videos (title)
values
	('v_first'),
	('v_second'),
	('v_third');

insert into users (nickname)
values
	('u_first'),
	('u_second'),
	('u_third');


insert into videos_users (video_id, user_id)
values
	((select id from videos where title = 'v_first'), (select id from users where nickname = 'u_first')),
	((select id from videos where title = 'v_first'), (select id from users where nickname = 'u_second')),
	((select id from videos where title = 'v_second'), (select id from users where nickname = 'u_third'));


select
	v.id,
	v.title,
	v.publication_date,
	v.duration,
	coalesce (jsonb_agg(jsonb_build_object(
		'id', u.id,
		'nickname', u.nickname,
		'registration_date', u.registration_date
	)) filter (where u.id is not null), '[]') as users
from videos v
left join videos_users vu on v.id = vu.video_id
left join users u on u.id = vu.user_id
group by v.id;


select
	u.id,
	u.nickname,
	u.registration_date,
	coalesce (jsonb_agg(jsonb_build_object(
		'id', v.id,
		'title', v.title,
		'publication_date', v.publication_date,
		'duration', v.duration
	)) filter (where v.id is not null), '[]') as videos
from users u
left join videos_users vu on u.id = vu.user_id
left join videos v on v.id = vu.video_id
group by u.id;


drop table if exists videos, users, videos_users cascade;
