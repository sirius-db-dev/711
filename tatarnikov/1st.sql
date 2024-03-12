
create extension if not exists "uuid-ossp";

drop table if exists repos, devs, devs_to_repos cascade;

create table repos
(
	id uuid primary key default uuid_generate_v4(),
	repo_name text,
	description text,
	stars_count int
);

create table devs
(
	id uuid primary key default uuid_generate_v4(),
	nickname text
);

create table devs_to_repos
(
	repo_id uuid references repos,
	dev_id uuid references devs,
	primary key (repo_id, dev_id)
);

insert into repos(repo_name, description, stars_count)
values
('1st', 'ok', 5),
('2nd', 'k', 10),
('3st', 'o', 1);

insert into devs(nickname)
values
('qwwe'),
('hfjkds'),
('fsfssf');

insert into devs_to_repos(repo_id, dev_id)
values
((select id from repos where repo_name = '1st'), (select id from devs where nickname = 'qwwe')),
((select id from repos where repo_name = '2nd'), (select id from devs where nickname = 'qwwe')),
((select id from repos where repo_name = '3st'), (select id from devs where nickname = 'qwwe')),
((select id from repos where repo_name = '1st'), (select id from devs where nickname = 'hfjkds')),
((select id from repos where repo_name = '3st'), (select id from devs where nickname = 'fsfssf'));


select
  a.id,
  a.nickname,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'name', f.repo_name, 'description', f.description, 'stars', f.stars_count))
      filter (where f.id is not null), '[]') as repos
from devs a
left join devs_to_repos af on a.id = af.dev_id
left join repos f on f.id = af.repo_id
group by a.id;

select
  a.id,
  a.repo_name,
  a.description,
  a.stars_count,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'nickname', f.nickname))
      filter (where f.id is not null), '[]') as devs
from repos a
left join devs_to_repos af on a.id = af.repo_id
left join devs f on f.id = af.dev_id
group by a.id;

