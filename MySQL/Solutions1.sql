# 1
SHOW TABLES;

# 2
SELECT owner, name from pet;

# 3
select birth from pet where species='dog';

# 4
select name from pet where MONTH(birth) < 7;

# 5
SELECT species from pet where sex='m';

# 6
SELECT name, date from event where remark like 'Gave%';

# 7
select owner from pet where name like '%ffy';

# 8
SELECT owner, name from pet where death IS NULL;

# 9
select owner, count(*) from pet GROUP BY owner HAVING count(*) > 1;

# 10
SELECT owner, name from pet where MONTH(birth) < MONTH(CURDATE()) and date(birth) < date(CURDATE());

# 11
select name from pet where year(birth)>1992 and DATE_FORMAT(birth, '%Y-%m') < '1994-07';

# 12
select name from pet where death is NULL ORDER BY birth LIMIT 2;

# 13
SELECT name, birth from pet where birth = (select max(birth) from pet);

# 14
SELECT owner from pet join event e on pet.name = e.name WHERE e.date > (select date from event where name='Slim');

# 15
select owner from pet join event e on pet.name = e.name where type!='birthday' order by birth;

# 16
select p1.owner, p2.owner from pet as p1 join pet as p2 where p1.species=p2.species and p1.owner>p2.owner;

# 17
ALTER TABLE menagerie.event add column performer VARCHAR(255);

# 18
UPDATE event join pet p on event.name = p.name SET performer=owner WHERE type!='vet' and type!='litter';

# 19
UPDATE pet SET owner='Diane' WHERE species='cat';

# 20
SELECT species, COUNT(*) from pet GROUP BY species;

# 21
DELETE from pet where death is not null;

# 22
ALTER TABLE pet DROP COLUMN death;

# 23
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
                         
