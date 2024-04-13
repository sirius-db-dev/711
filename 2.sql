DROP TABLE IF EXISTS game, buyer, game_to_buyer;

create TABLE game
(
    id          int primary key generated by default as identity,
    name        text,
    genre       text,
    price       int
    
);

CREATE TABLE buyer
(
    id          int primary key generated by default as identity,
    nickname    text,
    date_reg    text
);

CREATE TABLE game_to_buyer
(
    game_id      int REFERENCES game,
    buyer_id         int REFERENCES buyer,
    PRIMARY KEY (game_id, buyer_id)

);

INSERT INTO game(name, genre, price)
VALUES ('Ам-ням', 'детям', 100),
       ('Квест', 'головоломка', 500),
       ('дом мертвых', 'ужасы', 700);

INSERT INTO buyer(nickname, date_reg)
VALUES ('vovavovv', '2009-01-01'),
       ('none_1', '2011-11-11'),
       ('qwerty', '2000-01-01'),
       ('rybka', '2020-01-02');

INSERT INTO game_to_buyer(game_id, buyer_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (2, 3);

SELECT
    b.id,
    b.nickname,
    b.date_reg,
    coalesce(json_agg(json_build_object(
        'id', g.id, 
        'name', g.name,
        'жанр', g.genre, 
        'цена', g.price))filter (where g.id is not null), '[]') as game
FROM buyer b
LEFT JOIN game_to_buyer gb on b.id = gb.buyer_id
LEFT JOIN game g on g.id = gb.game_id
GROUP BY b.id;


SELECT
    g.id,
    g.name,
    g.genre,
    g.price,
    coalesce(json_agg(json_build_object(
        'id', b.id, 
        'nickname', b.nickname, 
        'дата регистрации', b.date_reg))
filter (where b.id is not null), '[]') as buyer
from game g
left join game_to_buyer gb on g.id = gb.game_id
left join buyer b on b.id = gb.buyer_id
group by g.id;