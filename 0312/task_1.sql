/*
1. Репозитории и разработчики:
у разработчика может быть много репозиториев
в репозиторий может вносить изменения несколько разработчиков
репозиторий - название, описание, количество звезд
разработчик - никнейм
*/


create extension if not exists "uuid-ossp";

drop table if exists repositories, developers, repositories_to_developers cascade;

create table repositories
(
    id uuid primary key default uuid_generate_v4(),
    name text,
    description text,
    star_quantity int
);

create table developers
(
    id uuid primary key default uuid_generate_v4(),
    nickname text
);

create table repositories_to_developers
(
    repository_id uuid references repositories,
    developer_id uuid references developers,
    primary key (repository_id, developer_id)
);

insert into repositories(name, description, star_quantity)
values
('damn-house', 'horror', 5),
('super-duper-mega-extra-doctor', 'some super-duper-mega-extra text', 5),
('math-functions', 'math functions', 3),
('http-server-on-python', 'my http server', 4),
('no-name', 'no-text', 1);

insert into developers(nickname)
values
('mixa777'),
('darvenommm'),
('ilya-danilov'),
('some_cool_dev');

insert into repositories_to_developers(repository_id, developer_id)
values
    ((select id from repositories where name = 'damn-house'),
     (select id from developers where nickname = 'mixa777')),
    ((select id from repositories where name = 'damn-house'),
     (select id from developers where nickname = 'darvenommm')),
    ((select id from repositories where name = 'super-duper-mega-extra-doctor'),
     (select id from developers where nickname = 'mixa777')),
    ((select id from repositories where name = 'super-duper-mega-extra-doctor'),
     (select id from developers where nickname = 'darvenommm')),
    ((select id from repositories where name = 'math-functions'),
     (select id from developers where nickname = 'ilya-danilov')),
    ((select id from repositories where name = 'math-functions'),
     (select id from developers where nickname = 'darvenommm')),
    ((select id from repositories where name = 'http-server-on-python'),
     (select id from developers where nickname = 'ilya-danilov')),
    ((select id from repositories where name = 'http-server-on-python'),
     (select id from developers where nickname = 'darvenommm'));

select
	repositories.id,
	name,
	description,
	star_quantity,
	coalesce(jsonb_agg(jsonb_build_object(
		'id', developers.id,
		'nickname', developers.nickname))
			filter (where developers.id is not null), '[]') as developers
from repositories
left join repositories_to_developers on repositories.id = repositories_to_developers.repository_id
left join developers on developers.id = repositories_to_developers.developer_id
group by repositories.id;