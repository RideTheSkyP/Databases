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
