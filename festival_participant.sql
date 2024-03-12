drop table if exists festival, participant, festival_to_participant cascade;

create table festival
(
	id int primary key,
	title_festival text,
	date_festival date,
	place text
);

create table participant
(
	id int primary key,
	first_name text,
	last_name text,
	date_birth date
);

create table festival_to_participant
(
	festival_id int references festival,
	participant_id int references participant,
	primary key(festival_id, participant_id)
);

insert into festival(id, title_festival, date_festival, place)
values
(1, 'festival1', '2022-10-13', 'place1'),
(2, 'festival2', '2020-07-19', 'place2'),
(3, 'festival3', '2021-02-15', 'place3');

insert into participant(id, first_name, last_name, date_birth)
values
(1, 'First name1', 'Last name1', '2000-06-04'),
(2, 'First name2', 'Last name2', '2004-12-11'),
(3, 'First name3', 'Last name3', '1993-09-28'),
(4, 'First name4', 'Last name4', '2001-04-16');

insert into festival_to_participant(festival_id, participant_id)
values
	(1, 2),
	(1, 3),
	(2, 3),
	(2, 4),
	(3, 1),
	(3, 2),
	(3, 3);

select 
	fv.id,
	fv.title_festival,
	fv.date_festival,
	fv.place,
	coalesce(jsonb_agg(json_build_object('id', pat.id, 'first_name',
	pat.first_name, 'last_name', pat.last_name, 'date_birth', pat.date_birth))
	filter(where pat.id is not null), '[]') as participant
from festival fv
left join festival_to_participant fv_pat on fv.id = fv_pat.festival_id
left join participant pat on pat.id = fv_pat.festival_id
group by fv.id;

select 
	pat.id,
	pat.first_name,
	pat.last_name,
	pat.date_birth,
	coalesce(jsonb_agg(json_build_object('id', fv.id, 'title_festival', fv.title_festival, 'date_festival', fv.date_festival,
	'place', fv.place))
	filter(where fv.id is not null), '[]') as festival
from participant pat
left join festival_to_participant fv_pat on pat.id = fv_pat.participant_id
left join festival fv on pat.id = fv_pat.festival_id
group by pat.id;