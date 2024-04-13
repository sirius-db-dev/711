drop table if exists recept, commen cascade;

create table recept(
id int primary key, 
name_recept varchar(30),
category text,
description text
);


create table commen(
id int primary key, 
id_recept int references recept,
text_commen text,
date_commen date
);

insert into recept(id, name_recept, category, description) values
(1, 'olivye', 'salat', 'feefzdfscx'),
(2, 'black price', 'cake', 'asdfaew'),
(3, 'pasta', '&&&', 'sadadqw');

insert into commen(id, id_recept, text_commen, date_commen) values
(1, 1, 'Wow', '02-02-2003'),
(2, 1, 'Excelent', '04-02-2009'),
(3, 2, 'Num-num', '05-07-2012'),
(4, 2, '_/(* *)\_', '05-07-2023');

select * from recept;
select * from commen;

select recept.id, recept.name_recept, recept.category, recept.description,
coalesce(json_agg(json_build_object(
'commen_id', commen.id, 'text_commen', commen.text_commen, 'date_commen', commen.date_commen))
filter(where commen.id is not null), '[]') as commen
from recept
left join commen on recept.id = commen.id_recept
group by recept.id;



