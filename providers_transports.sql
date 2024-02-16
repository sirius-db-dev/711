drop table if exists providers, transports cascade;

create table providers 
(
	id int primary key,
	title_providers text,
	phone_number text
);

create table transports
(	
	id int,
	providers_id int references providers,
	brand text,
	model text,
	capacity int
);

insert into providers(id, title_providers, phone_number)
values
(1, 'Provider1', '89232599013'),
(2, 'Provider2', '89282077356'),
(3, 'Provider3', '89734846118');

insert into transports(id, providers_id, brand, model, capacity)
values
(1, 3, 'Nissan', 'M2', 4500),
(2, 1, 'Toyota', 'Nf4', 5600),
(3, 2, 'Hyundai', 'Ih5', 3900),
(4, 1, 'Honda', 'Mnw', 4800);

select 
	pv.id,
	pv.title_providers,
	pv.phone_number,
	coalesce(json_agg(jsonb_build_object('id', ts.id, 'brand', ts.brand, 
	'model', ts.model, 'capacity', ts.capacity))
	filter(where ts.id is not null), '[]') as transports
from providers pv
left join transports ts on pv.id = ts.providers_id
group by pv.id;