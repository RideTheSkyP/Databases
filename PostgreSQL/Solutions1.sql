-- 1
select * from pg_catalog.pg_tables where schemaname='public';
-- 2
select owner from pet;
-- 3
select birth from pet where species='dog';
-- 4
select name from pet where extract(MONTH from birth)<7;
-- 5
select species from pet where sex='m';
-- 6
select name, date from event where remark like 'Gave%';
-- 7
select owner from pet where name like '%ffy';
-- 8
select owner, name from pet where death is null;
-- 9
select owner, count(*) from pet GROUP BY owner HAVING count(*)>1;
-- 10
select owner, name from pet where species='dog' and extract(MONTH from birth) < extract(month from current_date) order by name desc;
-- 11
select name from pet where extract(year from birth) > 1992 and to_char(birth, 'YYYY-MM') < '1994-07';
-- 12
select name from pet ORDER BY birth LIMIT 2;
-- 13
select name from pet where birth=(select max(birth) from pet);
-- 14
select owner from pet p join event e on p.name = e.name where e.date>(select date from event where name='Slim');
-- 15
select owner from pet join event e on pet.name = e.name where e.type!='birthday' order by pet.birth;
-- 16
select p1.owner, p2.owner from pet p1, pet p2 where p1.species=p2.species and p1.owner<p2.owner;
-- 17
alter table event add column performer varchar(20);
-- 18
update event set performer=(select owner from pet p where p.name = event.name) where type!='vet' and type!='litter';
-- 19
update pet set owner='Diane' where species='cat';
-- 20
select species, count(*) from pet group by species order by count(*) desc;
-- 21
delete from pet where death is not null;
-- 22
alter table pet drop column death;
-- 23
INSERT INTO pet VALUES ('Muffy', 'Denny', 'goat', 'f', '1990-02-14'),
                       ('Duffy', 'Denny', 'hamster', 'f', '1998-10-23'),
                       ('Buddy', 'Sam', 'dog', 'm', '1992-08-21'),
                       ('Molly', 'Sam', 'sheep', 'f', '1999-11-02'),
                       ('Charlie', 'Jack', 'dog', 'm', '1991-05-16'),
                       ('Lucy', 'Sam', 'goat', 'f', '1995-09-27'),
                       ('Toby', 'Jack', 'goat', 'm', '1993-04-23');

INSERT INTO event VALUES ('Muffy', '1991-02-14', 'birthday', 'Gave her a new bell'),
                         ('Duffy', '2000-07-28', 'vet', 'broken leg'),
                         ('Buddy', '1994-12-03', 'litter', '2 puppies, 1 female, 1 male'),
                         ('Molly', '2002-11-02', 'birthday', 'Third birthday'),
                         ('Charlie', '1995-11-29', 'vet', 'eye disease'),
                         ('Lucy', '1997-02-10', 'litter', '3 goats, 1 female, 2 male'),
                         ('Toby', '1996-04-23', 'birthday', 'Gave him some tasty things');

