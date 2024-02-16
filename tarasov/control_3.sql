/*
 * 
 * ### 3. Покупатели и заказы:
 - покупатель может иметь несколько заказов
 - заказ принадлежит только одному покупателю
 - покупатель - имя, фамилия, телефон
 - заказ - дата, сумма
 * 
 */
 
DROP TABLE IF EXISTS customer, booking CASCADE;

CREATE TABLE IF NOT EXISTS customer(
 	id INTEGER PRIMARY KEY,
 	name TEXT,
 	surname TEXT,
 	phone TEXT
 );
 
CREATE TABLE IF NOT EXISTS booking(
	id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	date DATE,
	price INTEGER,
	customer_id INTEGER REFERENCES customer(id)
);

INSERT INTO customer VALUES 
(1, 'Misha', 'Tarasov', '719139131'),
(2, 'Denis', 'Romodanov', '719139131'),
(3, 'Vadim', 'Tararnikov', '719139131');

INSERT INTO booking (date, price, customer_id) VALUES
(now(), 500, 1),
(now(), 900, 1),
(now(), 300, 2);

SELECT c,
COALESCE(
json_agg(json_build_object(
	'booking_id', b.id,
	'date', b.date,
	'price', b.price,
	'customer_id', b.customer_id
)) FILTER(WHERE b.id IS NOT null), '[]') AS booking
FROM customer c
LEFT JOIN booking b ON c.id = b.customer_id
GROUP BY c.id