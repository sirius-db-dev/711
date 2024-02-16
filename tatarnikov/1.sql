drop table if exists tasks_, comments_;

create table tasks_
(
	id int primary key,
	name_ text,
	description text,
	level_ text
);

create table comments_
(
	id int primary key,
	task_id int references tasks_,
	data_ text,
	pub_date date
);

insert into tasks_ (id, name_, description, level_)
values
(1, 'aaa', 'ok', 'easy'),
(2, 'bbb', 'ehh', 'medium');


insert into comments_ (id, task_id, data_, pub_date)
values
(1, 2, 'nononon', '2019.05.05'),
(2, 2, 'kkkkkkk', '2022.03.03'),
(3, 1, 'fhkjs', '2012.03.03'),
(4, 1, 'Sochi', '2056.03.03');

select
	tk.id,
	tk.name_,
	tk.description,
	tk.level_,
	coalesce(
		json_agg(
			json_build_object(
				'task_id', cm.task_id,
				'comment_id', cm.id,
				'data', cm.data_,
				'pub_date', cm.pub_date
				)
			) filter (where cm.id is not null),
		'[]'
		)
		as city
from tasks_ tk
left join comments_ cm on tk.id = cm.task_id
group by tk.id;