# 1

# 2

# 3
create table Musicians(
    id int auto_increment primary key,
    name varchar(70),
    surname varchar(90),
    band int,
    salary int unsigned,
    foreign key(band) references Band(id)) AUTO_INCREMENT=1;

create procedure insertHumans()
begin
    declare cnt int unsigned default 0;
    set @num = (select count(*) from Music.Band);
    while cnt < @num do
        set @curPeople = 0;
        set @people = (select floor(rand() * (7-1) + 1));
        while @curPeople < @people do
            set @name = (select floor(rand() * (100000-1) + 1));
            set @surname = (select floor(rand() * (100000-1) + 1));
            set @salary = (select floor(rand() * (100000-1000) + 1000));
            insert into Musicians(name, surname, band, salary) select @name, @surname, cnt+1, @salary;
            set @curPeople = @curPeople + 1;
        end while;
        set cnt = cnt + 1;
    end while;
end;

drop procedure insertHumans;
call insertHumans();
# 4
create table Passwords(
    id int,
    password varchar(256)
);
create procedure hashPassword(in nm varchar(150), in password varchar(256))
begin
    set @st = (select count(*) from Musicians where Musicians.name=nm);
    if @st = 1
    then
        insert into Passwords(id, password) select id, md5(password) from Musicians where Musicians.name=nm;
        select Band.name from Band inner join Musicians on Band.id = Musicians.band where Musicians.name=nm;
    else
        SELECT name FROM Band ORDER BY RAND() LIMIT 1;
    end if;
end;

drop procedure hashPassword;
call hashPassword('22467', 'pass');

create procedure checkPassword(in nm varchar(150), in password varchar(256))
begin
    set @st = (select count(*) from Musicians where Musicians.name=nm);
    if @st = 1
    then
        insert into Passwords(id, password) select id, md5(password) from Musicians where Musicians.name=nm;
        select Band.name from Band inner join Musicians on Band.id = Musicians.band inner join Passwords on Band.id=Passwords.id where Musicians.name=nm and Passwords.password=md5(password);
    else
        SELECT name FROM Band ORDER BY RAND() LIMIT 1;
    end if;
end;

drop procedure checkPassword;
call checkPassword('22', 'pass');
# 5
create procedure curToBand(in bnd varchar(70))
begin
    declare cursorVar int default 0;
    declare done int default 0;
    declare salaryList varchar(255) default '';
    declare salaryCur cursor for (select salary from Musicians inner join Band on Musicians.band = Band.id where Band.name=bnd);
    declare continue handler for not found set done = 1;
    open salaryCur;
    cur: LOOP
        fetch salaryCur into cursorVar;
        if done = 1 then
            leave cur;
        end if;
        set salaryList = concat(cursorVar, ';', salaryList);
    end loop;
    select salaryList;
    close salaryCur;
end;

drop procedure curToBand;
call curToBand('AC/DC');
# 6
create procedure payments(in band varchar(70), in amount int)
begin
    declare cnt int unsigned default 0;
    DECLARE salaryOfMember int;
    declare salaryCur cursor for (select salary from Musicians inner join Band on Musicians.band = Band.id where Band.name=band);
    open salaryCur;
    start transaction;
    while cnt < (select count(*) from Musicians inner join Band on Musicians.band = Band.id where Band.name=band) do
        fetch salaryCur into salaryOfMember;
        set amount = amount - salaryOfMember;
        set cnt = cnt + 1;
    end while;
    COMMIT;
    if amount < 0 then
        rollback;
        select 'There is not correct amount of money, payment canceled';
    else
        select concat('Payment accepted, paid out to ', cnt, ' members, cash left: ', amount);
    end if;
    close salaryCur;
end;

drop procedure payments;
call payments('AC/DC', 1000000);
# 7
sudo mysqldump -u push -p Music > Music.sql;
drop database Music;
mysql -u push -p Music < Music.sql
# 9
SHOW VARIABLES LIKE "secure_file_priv";
select json_object('id', id, 'name', name, 'albumsAmount', albumsAmount) into outfile '/var/lib/mysql-files/Band.json' from Music.Band;
select json_object('id', id, 'title', title, 'timeSec', timeSec, 'album', album, 'band', band) into outfile '/var/lib/mysql-files/Track.json' from Music.Track;
select json_object('title', title, 'genre', genre, 'band', band) into outfile '/var/lib/mysql-files/Album.json' from Music.Album;

