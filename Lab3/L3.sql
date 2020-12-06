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

delimiter //;
create procedure insertHumans()
begin
    declare cnt int unsigned default 0;
    set @num = (select count(*) from Music.Band);
    while cnt < @num do
        set @curPeople = 0;
        set @people = (select floor(rand() * (7-1) + 1));
        set @bandName = (select floor(rand() * (select count(*) from Band)));
        while @curPeople < @people do
            set @name = (select floor(rand() * (100000-1) + 1));
            set @surname = (select floor(rand() * (100000-1) + 1));
            set @salary = (select floor(rand() * (100000-1000) + 1000));
            insert into Musicians(name, surname, band, salary) select @name, @surname, @bandName, @salary;
            set @curPeople = @curPeople + 1;
        end while;
        set cnt = cnt + 1;
    end while;
end; //

drop procedure insertHumans;
call insertHumans();
# 4
create table Passwords(
    id int,
    password varchar(256)
);
delimiter //;
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
# 5
DECLARE cursor CURSOR FOR (select salary);
select salary from Musicians inner join Band on Musicians.band = Band.id where Band.name=;

