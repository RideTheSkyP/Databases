# 1
create user '251507'@'localhost' identified by 'volodymyr507';
create database cameras;
grant select, update, insert on cameras to '251507'@'localhost';
use cameras;
# 2
create table Cameras(   model varchar(30),
                        manufacturer int unsigned,
                        matrix int unsigned,
                        lens int unsigned,
                        type enum('compact', 'SLRcamera', 'professional', 'other'),
                        primary key (model),
                        foreign key (manufacturer) references Manufacturer(id),
                        foreign key (matrix) references Matrix(id),
                        foreign key (lens) references Lens(id));
create table Matrix(id int unsigned auto_increment primary key,
                    diagonal decimal(4,2),
                    resolution decimal(3,1),
                    type varchar(10)) auto_increment=100;
create table Lens(  id int unsigned auto_increment primary key,
                    model varchar(30),
                    minShutter float,
                    maxShutter float);
create table Manufacturer(  id int unsigned auto_increment primary key,
                            title varchar(50),
                            country varchar(20));


CREATE TRIGGER shutterCheck BEFORE INSERT ON Lens
    FOR EACH ROW
    BEGIN IF minShutter < 0 or maxShutter < 0 or minShutter > maxShutter
        THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid state!';
    END IF;
END;
# 3
insert into Lens(model, minShutter, maxShutter)
values
('a', 19.5, 24.6),
('b', 14.5, 155.16),
('c', 12.2, 20.3),
('d', 10.6, 321.14),
('e', 51.7, 89.32),
('f', 17.002, 109.54),
('g', 26.01, 68.6),
('h', 80.43, 167.06),
('i', 70.21, 549.12),
('j', 62.177, 453.01),
('k', 13.9, 789.2),
('l', 90.1, 594.3),
('m', 65.89, 401.3),
('n', 19.6, 508.2),
('o', 11.1, 697.31);
insert into Manufacturer (title, country)
values
('Nikon', 'Japan'),
('Insta', 'USA'),
('Visual', 'Russia'),
('Temptation', 'France'),
('ExplorerCH', 'China'),
('Welcome', 'China'),
('Chinese&CO', 'China'),
('CHF', 'China'),
('J&A', 'China'),
('WhiteChapel', 'UK'),
('GR', 'Germany'),
('CompactFoto', 'Germany'),
('ThreeSticks', 'UK'),
('Cluster', 'Nigeria'),
('Budda', 'India');
insert into Matrix (diagonal, resolution, type)
values
(24.6, 19.5, 'a'),
(55.16, 14.5, 'b'),
(20.2, 20.3, 'c'),
(21.14, 10.6, 'v'),
(39.32, 31.7, 'qw'),
(17.02, 19.4, 'q'),
(38.6, 26.1, 'w'),
(67.06, 40.4, 'y'),
(49.12, 20.1, 'jb'),
(53.01, 12.7, 'ui'),
(9.2, 3.9, 'yo'),
(9.1, 4.3, 'yhnb'),
(5.89, 1.3, 'mxc'),
(19.6, 8.2, 'cvxc'),
(11.1, 7.3, 'fsafa');
# 4
create procedure insertCameras(in num int)
begin
    declare i int default 0;
    declare manufacturer_id int unsigned default 0;
    declare matrix_id int unsigned default 0;
    declare model_name varchar(30) default NULL;
    declare lens_id int unsigned default 0;
    declare type_name varchar(30) default NULL;
    l: loop
        if i < num then
            set i = i + 1;

            set manufacturer_id = (select id from Manufacturer order by rand() limit 1);
            set matrix_id = (select id from Matrix order by rand() limit 1);
            set model_name = (select concat(model, floor((rand()*100 + 1))) from Lens order by rand() limit 1);
            set lens_id = (select id from Lens order by rand() limit 1);
            set type_name = (select elt(1 + rand() * 4, 'compact', 'SLRcamera', 'professional', 'other'));

            if (select model from Cameras
                where model_name = model) is NULL then

                insert into Cameras(model, manufacturer, matrix, lens, type)
                value (model_name, manufacturer_id, matrix_id, lens_id, type_name);
            end if;

            iterate l;
        end if;

        leave l;
    end loop l;
end;
drop procedure insertCameras;
call insertCameras(100);
# 5
create procedure findModel(in inId int)
begin
    select model from Cameras C
        inner join Matrix M on C.matrix = M.id
        inner join Manufacturer P on C.manufacturer = P.id
    where P.id=inId and M.diagonal=(select max(diagonal) from Matrix);
end;
call findModel(1);
# 6
CREATE TRIGGER insertCamera BEFORE INSERT ON Cameras.Cameras
    FOR EACH ROW
    BEGIN IF (select count(new.manufacturer) from Manufacturer) = 0
        THEN
            insert into Manufacturer(id) values (new.manufacturer); ;
    END IF;
END;
# 7
CREATE FUNCTION returnCountModels(
    matrixId int
)
RETURNS int
DETERMINISTIC
BEGIN
    select count(model) from Cameras where matrix=matrixId;
END;
# 8
CREATE TRIGGER deleteMatrix after delete on Cameras
    FOR EACH ROW
    BEGIN IF (select count(matrix) from Cameras where matrix=old.matrix )= 0
        THEN
            delete from Matrix where id=old.matrix;
    END IF;
END;
# 9
CREATE VIEW SLRview
AS
SELECT M2.title ,M2.country, M.diagonal, M.resolution, L.minShutter, L.maxShutter
FROM Cameras C
inner join Matrix M on C.matrix = M.id
inner join Lens L on C.lens = L.id
inner join Manufacturer M2 on C.manufacturer = M2.id
where C.type='SLRcamera' and M2.country<>'China';
drop view SLRview;
select * from SLRview;
# 10
CREATE VIEW camerasView
AS
SELECT M.title, M.country, C.model
FROM Cameras C
inner join Manufacturer M on C.manufacturer = M.id;

drop view camerasView;

select * from camerasView;

delete from Cameras where manufacturer in (select id from Manufacturer where country='China');
# 11
alter table Manufacturer
add model_count int unsigned;

update Manufacturer
inner join (select manufacturer, count(model) as num from Cameras group by manufacturer) as dev
on Manufacturer.id = dev.manufacturer
set
    Manufacturer.model_count = dev.num;

create trigger delete_device after delete on Cameras
for each row
begin
    if (select manufacturer from Cameras where manufacturer = old.manufacturer) is NULL
    then
        delete from Manufacturer where id = old.manufacturer;
    end if;
    update Manufacturer
    inner join (select manufacturer, count(model) as num from Cameras group by manufacturer) as dev
    on Manufacturer.id = dev.manufacturer
    set
            Manufacturer.model_count = dev.num;
end;


create trigger update_device after update on Manufacturer
for each row
begin
    IF (select count(new.title) from Manufacturer) = 0
    THEN
        insert into Manufacturer(id)
        values (new.title);
    END IF;

    update Manufacturer
    inner join (select manufacturer, count(model) as num from Cameras group by manufacturer) as cam
    on Manufacturer.id = cam.manufacturer
    set
        Manufacturer.model_count = cam.num;
end ;

CREATE TRIGGER insertCameras BEFORE INSERT ON Cameras
    FOR EACH ROW
    BEGIN
        IF (select new.manufacturer from Manufacturer) is NULL
        THEN
            insert into Manufacturer(id)
            values (new.manufacturer);
        END IF;

    update Manufacturer
    inner join (select manufacturer, count(model) as num from Cameras group by manufacturer) as cam
    on Manufacturer.id = cam.manufacturer
    set
        Manufacturer.model_count = cam.num;
END;