drop table if exists repositories, tickets cascade;

create table repositories
(
    id            int primary key, 
    name          text,
    description   text,
    stars         int
);

create table tickets
(
    id               int primary key,
    repositories_id  int references repositories, 
    name             text,
    description      text,
    status           text
);

insert into repositories(id, name, description, stars)
values (1, 'DZ', 'Homework', 2),
       (2, 'CW', 'Classwork', 4),
       (3, 'KR', 'Control point', 10);

insert into tickets(id, repositories_id, name, description, status)
values (1, 2, 'Баллы', 'Разбаловка', 'отправлено'),
       (2, 3, 'Баллы', 'Разбаловка работ', 'выполнено'),
       (3, 3, 'Итог', 'Итоговые отметки', 'сделано');

select
  repo.id,
  repo.name,
  repo.description,
  repo.stars,
  coalesce(json_agg(json_build_object(
    'id', ts.id, 'name', ts.name, 'description', ts.description, 'status', ts.status))
      filter (where ts.id is not null), '[]')
        as tickets
from repositories repo
left join tickets ts on repo.id = ts.repositories_id
group by repo.id;