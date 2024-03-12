/*
 * 
 *  Видео и пользователи:

    у видео может быть много просмотров от разных пользователей
    у пользователя может быть много просмотренных видео
    видео - название, дата публикации, длительность
    пользователь - никнейм, дата регистрации

 */

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS video, person, video_to_person CASCADE;

CREATE TABLE IF NOT EXISTS video (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	name VARCHAR(56),
	create_date DATE,
	longess INTEGER
);

CREATE TABLE IF NOT EXISTS person(
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	username VARCHAR(128),
	register_date DATE
);

CREATE TABLE IF NOT EXISTS video_to_person (
	person_id uuid REFERENCES person(id),
	video_id uuid REFERENCES video(id),
	PRIMARY KEY(person_id, video_id)
);

INSERT INTO video(name, create_date, longess) VALUES
('first', now(), 128),
('second', now(), 128),
('thrid', now(), 128);

INSERT INTO person(username, register_date) VALUES
('first', now()),
('second', now()),
('thrid', now());

INSERT INTO video_to_person(person_id, video_id) VALUES
(
	(SELECT id FROM person WHERE username = 'first'),
	(SELECT id FROM video WHERE name = 'first')
),
(
	(SELECT id FROM person WHERE username = 'second'),
	(SELECT id FROM video WHERE name = 'first')
),
(
	(SELECT id FROM person WHERE username = 'first'),
	(SELECT id FROM video WHERE name = 'second')
);

SELECT v,
COALESCE(
json_agg(json_build_object(
	'person_id', p.id,
	'username', p.username,
	'register_date', p.register_date
)) FILTER(WHERE p.id IS NOT NULL), '[]') AS persons
FROM video v
LEFT JOIN video_to_person vp ON v.id = vp.video_id
LEFT JOIN person p ON p.id = vp.person_id
GROUP BY v.id;

SELECT p,
COALESCE(
json_agg(json_build_object(
	'video_id', v.id,
	'name', v.name,
	'creation_date', v.create_date,
	'longess', v.longess
)) FILTER(WHERE v.id IS NOT NULL), '[]') AS videos
FROM person p
LEFT JOIN video_to_person vp ON p.id = vp.person_id
LEFT JOIN video v ON v.id = vp.video_id
GROUP BY p.id;
