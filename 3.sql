drop table if exists books, review cascade;

create table books
(
    id            int primary key, 
    name          text,
    genre         text,
    year          int
);

create table review
(
    id               int primary key,
    books_id         int references books, 
    textes           text,
    grade            int
);

insert into books(id, name, genre, year)
values (1, 'Азбука', 'для детей', 1999),
       (2, 'Словарь', 'научная литература', 1900),
       (3, 'Война и мир', 'классика', 1850),
       (4, 'Гарри поттер', 'фэнтези', 2005);

insert into review(id, books_id, textes, grade)
values (1, 2, 'Познавательно', 10),
       (2, 4, 'Итересно!!!', 15),
       (3, 4, 'qwert', 0),
       (4, 3, 'Хочу перечитать еще раз...', 100);

select
  bk.id,
  bk.name,
  bk.genre,
  bk.year,
  coalesce(json_agg(json_build_object(
    'id', rvw.id, 'text', rvw.textes, 'grade', rvw.grade))
      filter (where rvw.id is not null), '[]')
        as review
from books bk
left join review rvw on bk.id = rvw.books_id
group by bk.id;