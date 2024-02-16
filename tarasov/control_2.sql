/*
 * 
 * ### 2. Поставщики и транспортные средства:
 - поставщик может иметь несколько транспортных средств
 - транспортное средство может принадлежать только одному поставщику
 - поставщик - название, телефон
 - транспортное средство - марка, модель, грузоподъемность
 * 
 */

DROP TABLE IF EXISTS provider, transport CASCADE;

CREATE TABLE IF NOT EXISTS provider (
	id INTEGER PRIMARY KEY,
	name TEXT,
	phone TEXT
);

CREATE TABLE IF NOT EXISTS transport (
	id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	mark TEXT,
	model TEXT,
	weight_up INTEGER, --Не знаю как это точно перевести =)
	provider_id INTEGER REFERENCES provider(id)
);

INSERT INTO provider VALUES
(1, 'f_name', '891892019'),
(2, 's_name', '891892019'),
(3, 't_name', '891892019');

INSERT INTO transport (mark, model, weight_up, provider_id) VALUES
('bmw', 'm5', 500, 1),
('mercedes', 'GT', 500, 1),
('Lada Granta', 'Суетная', 500, 2);

SELECT p,
COALESCE(
json_agg(json_build_object(
	'mark', t.mark,
	'model', t.model,
	'weight_up', t.weight_up,
	'provider_id', t.provider_id
)) FILTER(WHERE t.id IS NOT NULL), '[]') AS transport
FROM provider p
LEFT JOIN transport t ON p.id = t.provider_id
GROUP BY p.id