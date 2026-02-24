create table table_customer (
	customerid FLOAT,
	createdate DATE,
	firstname VARCHAR(50),
	lastname VARCHAR(50),
	gender VARCHAR(10),
	city VARCHAR(50),
	phone VARCHAR(15),
	email VARCHAR(50)
);


insert into table_customer (customerid, createdate, firstname, lastname, gender, city, phone, email) 
values
(1001,	'2022-01-01',	'Louis', 'Zamora', 'Female', 'Christon',	'83784309701', 'ggreen@example.net'),
(1002,	'2022-01-01',	'Mary',	'Morales',	'Male',	'Petersonbury',	'88278750369',	'jeffrey29@example.org'),
(1003,	'2020-08-22',	'Michael',	'Harrell',	'Female',	'Ramirezport',	'82313618974',	'orozcobarry@example.com'),
(1004,	'2020-08-27',	'Jacob',	'Allen',	'Male',	'Rodriguezfort',	'88665417224',	'stephanienichols@example.org'),
(1005,	'2022-01-01',	'Joshua',	'Reilly',	'Female',	'Davischester',	'81895384230',	'davidmills@example.org');


alter table table_customer
rename column phone to phone_number;

alter table table_customer
alter column customerid type int;


select distinct createdate from table_customer;


select * from table_customer
order by createdate
limit 3;


select * from table_customer tc 
where createdate = '2022-01-01';


select * from table_customer tc 
where createdate in ('2020-08-22', '2020-08-27');


select * from table_customer tc 
where city in ('Petersonbury', 'Ramirezport', 'Davischester');


select * from table_customer tc 
where createdate between '2020-01-01' and '2020-12-31';


select * from table_customer tc 
where firstname like 'J%';















