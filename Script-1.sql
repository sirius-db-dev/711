create extension if not exists "uuid-ossp";
drop table if exists taxist, agregator, taxist_to_agregator cascade;

create table taxist (tax_id uuid primary key default uuid_generate_v4(), name text, surname text, number_phone text, car text);
create table agregator (agr_id uuid primary key default uuid_generate_v4(), name text, phone_number text);
create table taxist_to_agregator (taxist_id uuid references taxist, agregator_id uuid references agregator, primary key (taxist_id, agregator_id));

insert into taxist(name, surname, number_phone, car)
values 
('Gena', 'Oval', '88005553535', 'Lada'),
('Lena', 'Kvadrat', '89787234649', 'Volga'),
('Vanya', 'Tri', '89782234349', 'Nissan'),
('Katya', 'Kvadrat', '82487244649', 'Porche');

insert into agregator(name, phone_number)
values 
('"Ural"', '812352829148'),
('"Moscow"', '28271948292'),
('"Stalingrad"', '39284829248');

insert into taxist_to_agregator(taxist_id, agregator_id)
values
((select tax_id from taxist where name = 'Gena'), (select agr_id from agregator where name = '"Ural"')),
((select tax_id from taxist where name = 'Lena'), (select agr_id from agregator where name = '"Moscow"')),
((select tax_id from taxist where name = 'Lena'), (select agr_id from agregator where name = '"Ural"')),
((select tax_id from taxist where name = 'Vanya'), (select agr_id from agregator where name = '"Moscow"')),
((select tax_id from taxist where name = 'Katya'), (select agr_id from agregator where name = '"Ural"'));


select * from taxist
				left join taxist_to_agregator on taxist.tax_id = taxist_to_agregator.taxist_id
				left join agregator on taxist_to_agregator.agregator_id = agregator.agr_id;
			
select
  taxist.tax_id,
  taxist.surname,
  taxist.,
  taxist.car,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', agregator.agr_id, 'phone_agr', agregator.phone_number, 'name_agr', agregator.name))
      filter (where agregator.agr_id is not null), '[]') as agregator
from taxist
	left join taxist_to_agregator on taxist.tax_id = taxist_to_agregator.taxist_id
	left join agregator on agregator.agr_id = taxist_to_agregator.agregator_id
group by taxist.tax_id;

select
  agregator.name,
  agregator.phone_number,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', taxist.tax_id, 'phone_agr', taxist.number_phone, 'name_tax', taxist.name, 'surname', taxist.surname))
      filter (where taxist.tax_id is not null), '[]') as taxist
from agregator
	left join taxist_to_agregator on agregator.agr_id = taxist_to_agregator.agregator_id
	left join taxist on taxist.tax_id = taxist_to_agregator.taxist_id
group by agregator.agr_id;

