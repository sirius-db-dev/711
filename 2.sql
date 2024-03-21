drop table if exists game, review cascade;

create table game
(
    id            int primary key, 
    name          text,
    genre         text,
    price         float
);

create table review
(
    id               int primary key,
    game_id          int references game, 
    textes           text,
    grade            int
);

insert into game(id, name, genre, price)
values (1, 'стоматолог', 'для детей', 222.8),
       (2, 'квест', 'на логику', 450.0),
       (3, 'Гарри поттер', 'фэнтези', 1000.99);

insert into review(id, game_id, textes, grade)
values (1, 2, 'Cкучно!', 0),
       (2, 3, 'Итересно!!!', 4),
       (3, 3, 'Хочу пройти еще раз...', 100);

select
  gm.id,
  gm.name,
  gm.genre,
  gm.price,
  coalesce(json_agg(json_build_object(
    'id', rvw.id, 'text', rvw.textes, 'grade', rvw.grade))
      filter (where rvw.id is not null), '[]')
        as review
from game gm
left join review rvw on gm.id = rvw.game_id
group by gm.id;