--курьер может иметь несколько заказов
--заказ может принадлежать только одному курьеру
--курьер - имя, фамилия, телефон
--заказ - адреса, дата, статус

CREATE TABLE couriers (
    id int PRIMARY KEY,
    first_name text
    last_name text,
    phone text
);

INSERT INTO orders (id, address, order_date, status, courier_id) 
VALUES
(1, '123 Main St', '2022-01-15', 'Delivered', 1),
(2, '456 Elm St', '2022-01-16', 'In Transit', 1),
(3, '789 Oak St', '2022-01-17', 'Pending', 2),
(4, '321 Pine St', '2022-01-18', 'Delivered', 2),
(5, '555 Maple St', '2022-01-19', 'In Transit', NULL);

CREATE TABLE orders (
    id int PRIMARY KEY,
    address text,
    order_date text,
    status text,
    courier_id int,
    courier_id REFERENCES couriers(id)
);

INSERT INTO couriers (id, first_name, last_name, phone) 
VALUES
(1, 'John', 'Doe', '123-456-7890'),
(2, 'Jane', 'Smith', '987-654-3210');

SELECT 
	c.id, 
	c.first_name, 
	c.last_name, 
	c.phone,
       coalesce(jsonb_agg(jsonb_build_object(('order_id', o.id, 'address', 
       o.address, 'order_date', o.order_date, 'status', o.status)
       filter (where o.id is not null), '[]') as orders
FROM couriers c
LEFT JOIN orders o ON c.id = o.courier_id
GROUP BY c.id;

SELECT 
	o.id, 
	o.address, 
	o.order_date, 
	o.status,
       coalesce(jsonb_agg(json_build_object(('courier_id', c.id, 'first_name', 
       c.first_name, 'last_name', c.last_name, 'phone', c.phone) 
       filter (where c.id is not null), '[]') as courier
FROM orders o
LEFT JOIN couriers c ON o.courier_id = c.id;



--поставщик может иметь несколько транспортных средств
--транспортное средство может принадлежать только одному поставщику
--поставщик - название, телефон
--транспортное средство - марка, модель, грузоподъемность

CREATE TABLE suppliers (
    id int PRIMARY KEY,
    name_ text,
    phone text
);

INSERT INTO suppliers (id, name_, phone) VALUES
(1, 'Supplier A', '111-222-3333'),
(2, 'Supplier B', '444-555-6666');

CREATE TABLE vehicles (
    id int PRIMARY KEY,
    make text,
    model text,
    capacity int,
    supplier_id INT,
   	supplier_id) REFERENCES suppliers(id)
);


INSERT INTO vehicles (id, make, model, capacity, supplier_id) VALUES
(1, 'Toyota', 'Camry', 1000, 1),
(2, 'Ford', 'F-150', 1500, 1),
(3, 'Nissan', 'Altima', 1200, NULL);


SELECT 
	s.id, 
	s.name_, 
	s.phone,
       coalesce(jsonb_agg(json_build_object('vehicle_id', v.id, 'make', 
       v.make, 'model', v.model, 'capacity', v.capacity)
       filter (where v.id is not null), '[]') as vehicles
FROM suppliers s
LEFT JOIN vehicles v ON s.id = v.supplier_id
GROUP BY s.id;


SELECT 
	v.id, 
	v.make, 
	v.model, 
	v.capacity,
       coalesce(jsonb_agg(json_build_object('supplier_id', s.id, 'name', s.name_,'phone', s.phone)
       filter (where s.id is not null) '[]') as supplier
FROM vehicles v
LEFT JOIN suppliers s ON v.supplier_id = s.id;


--рецепт может иметь несколько комментариев
--комментарий может принадлежать только одному рецепту
--рецепт - название, описание, категория
--комментарий - текст, дата публикации

CREATE TABLE recipes (
    id int PRIMARY KEY,
    name_ text,
    description text,
    category text
);

CREATE TABLE comments (
    id int PRIMARY KEY,
    text_ text,
    publication_date date,
    recipe_id int,
   	recipe_id REFERENCES recipes(id)
);

INSERT INTO recipes (id, name_, description, category) 
VALUES
(1, 'Pasta Carbonara', 'Classic Italian pasta', 'Main Course'),
(2, 'Chocolate Cake', 'Decadent and moist chocolate', 'Dessert');


INSERT INTO comments (id, text_, publication_date, recipe_id) 
VALUES
(1, 'This pasta is amazing!', '2022-01-15', 1),
(2, 'Best chocolate cake ever!', '2022-02-05', 2),
(3, 'The salmon was perfectly cooked.', '2022-03-20', 1);

SELECT 
	r.id, 
	r.name_, 
	r.description, 
	r.category,
       coalesce(jsonb_agg(json_build_object('comment_id', c.id, 'text', c.text_,
       'publication_date', c.publication_date)
       filter (where c.id is not null), '[]') as comments
FROM recipes r
LEFT JOIN comments c ON r.id = c.recipe_id
GROUP BY r.id;



SELECT 
	c.id, 
	c.text_, 
	c.publication_date,
       coalesce(jsonb_agg(json_build_object('recipe_id', r.id, 'name', r.name_, 
       'description', r.description, 'category', r.category)
       filter (where r.id is not null), '[]') as recipe
FROM comments c
LEFT JOIN recipes r ON c.recipe_id = r.id;

    
    
    
    
    
    
    
 

