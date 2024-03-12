/*
 * 
2. Задачи и исполнители:

    у исполнителя может быть много задач
    задача могут решать несколько исполнителей
    задача - название, описание, статус
    исполнитель - имя, фамилия, должность
 */

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS task, executor, executor_to_task CASCADE;

CREATE TABLE IF NOT EXISTS task (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	name VARCHAR(128),
	description TEXT,
	status TEXT --Для простоты, лучше enum
);

CREATE TABLE IF NOT EXISTS executor(
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	name VARCHAR(128),
	surname VARCHAR(512), --Есть реально длинные фамилии
	work VARCHAR(56)
);

CREATE TABLE IF NOT EXISTS executor_to_task(
	executor_id uuid REFERENCES executor(id),
	task_id uuid REFERENCES task(id),
	PRIMARY KEY(executor_id, task_id)
);

INSERT INTO executor(name, surname, work) VALUES
('first', 'firstov', 'somejob'),
('second', 'secondov', 'somejob'),
('thrid', 'thridov', 'somejob');


INSERT INTO task(name, description, status) VALUES
('first', '..............', 'executing'),
('second', '..............', 'executing'),
('thrid', '..............', 'executing');

INSERT INTO executor_to_task VALUES
(
	(SELECT id FROM executor WHERE name = 'first'),
	(SELECT id FROM task WHERE name = 'first')
),
(
	(SELECT id FROM executor WHERE name = 'second'),
	(SELECT id FROM task WHERE name = 'first')
),
(
	(SELECT id FROM executor WHERE name = 'second'),
	(SELECT id FROM task WHERE name = 'second')
);

SELECT t,
COALESCE(
json_agg(json_build_object(
	'executor_id', e.id,
	'name', e.name,
	'surname', e.surname
)) FILTER(WHERE e.id IS NOT NULL), '[]') AS executors
FROM task t
LEFT JOIN executor_to_task et ON t.id = et.task_id
LEFT JOIN executor e ON e.id = et.executor_id
GROUP BY t.id;

SELECT e,
COALESCE(
json_agg(json_build_object(
	'task_id', t.id,
	'name', t.name,
	'description', t.description,
	'status', t.status
)) FILTER(WHERE t.id IS NOT NULL), '[]') AS tasks
FROM executor e
LEFT JOIN executor_to_task et ON e.id = et.executor_id
LEFT JOIN task t ON t.id = et.task_id
GROUP BY e.id;
