/*
 * 
 *  
 * 3. Фестивали и участники

    в фестивале могут принимать участие несколько людей
    человек может принимать участие в нескольких фестивалях
    фестиваль - название, дата, место
    человек - имя, фамилия, дата рождения
 */

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS festival, human, festival_to_human CASCADE;

CREATE TABLE IF NOT EXISTS festival(
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	name VARCHAR(128),
	festival_date DATE,
	place VARCHAR(512)
);

CREATE TABLE IF NOT EXISTS human(
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	name VARCHAR(128),
	surname VARCHAR(512),
	birthday DATE
);

CREATE TABLE festival_to_human(
	festival_id uuid REFERENCES festival(id),
	human_id uuid REFERENCES human(id),
	PRIMARY KEY(festival_id, human_id)
);

INSERT INTO festival(name, festival_date, place) VALUES
('first', now(), 'someplace'),
('second', now(), 'someplace'),
('thrid', now(), 'someplace');

INSERT INTO human(name, surname, birthday) VALUES
('first', 'firstov', now()),
('second', 'secondov', now()),
('thrid', 'thridov', now());

INSERT INTO festival_to_human VALUES
(
	(SELECT id FROM festival WHERE name = 'first'),
	(SELECT id FROM human WHERE name = 'first')
),
(
	(SELECT id FROM festival WHERE name = 'second'),
	(SELECT id FROM human WHERE name = 'first')
),
(
	(SELECT id FROM festival WHERE name = 'second'),
	(SELECT id FROM human WHERE name = 'second')
);

SELECT h,
COALESCE(
json_agg(json_build_object(
	'festival_id', f.id,
	'festival_date', f.festival_date,
	'place', f.place
)) FILTER(WHERE f.id IS NOT NULL), '[]') AS festivals
FROM human h
LEFT JOIN festival_to_human fh ON h.id = fh.human_id
LEFT JOIN festival f ON f.id = fh.festival_id
GROUP BY h.id;

SELECT f,
COALESCE(
json_agg(json_build_object(
	'human_id', h.id,
	'name', h.name,
	'surname', h.surname,
	'birthday', h.birthday
)) FILTER(WHERE h.id IS NOT NULL), '[]') AS humans
FROM festival f
LEFT JOIN festival_to_human fh ON f.id = fh.festival_id
LEFT JOIN human h ON h.id = fh.human_id
GROUP BY f.id;






