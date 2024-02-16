/*
## Создать таблицы и задать связи, заполнить данными для следующих примеров:

### 1. Книги и отзывы:
- книга может иметь несколько отзывов
- отзыв может принадлежать только одной книге
- книга - название, жанр, год издания
- отзыв - текст, оценка
*/

DROP TABLE IF EXISTS book, review CASCADE;


CREATE TABLE IF NOT EXISTS book (
	id INTEGER PRIMARY KEY,
	name TEXT,
	genre TEXT,
	year INTEGER
);

CREATE TABLE IF NOT EXISTS review (
	id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	review_text TEXT,
	mark INTEGER,
	book_id INTEGER REFERENCES book(id)
);

INSERT INTO book VALUES 
(1, 'first_book', 'drama', 2005),
(2, 'second_book', 'drama', 2005),
(3, 'thrid_book', 'drama', 2005);

INSERT INTO review(review_text, mark, book_id) VALUES
('somead amsodmasodmaosdmasomd', 5, 1),
('somead amsodmasodmaosdmasomd', 4, 1),
('somead amsodmasodmaosdmasomd', 3, 2);

SELECT b,
COALESCE(
json_agg(json_build_object(
	'review_id', r.id,
	'text', r.review_text,
	'mark', r.mark,
	'book_id', r.book_id
)) FILTER(WHERE r.id IS NOT null), '[]') AS review
FROM book b
LEFT JOIN review r ON b.id = r.book_id
GROUP BY b.id