# 1
create user 'user'@'localhost' identified by 'password';
grant select, update, insert on Music to 'user'@'localhost';
create database Music;
use Music;
# 2
create table Band(  id int auto_increment primary key,
                    name varchar(90),
                    albumsAmount int null);
create table Album( title varchar(160),
                    genre varchar(30),
                    band int,
                    primary key (title, band));
create table Track( id int unsigned auto_increment primary key,
                    title varchar(160),
                    time int,
                    album varchar(160),
                    band int,
                    foreign key(album) references Album(title),
                    foreign key(band) references Band(id)) AUTO_INCREMENT=1;

CREATE TRIGGER timeCheck BEFORE INSERT ON Track
    FOR EACH ROW
    BEGIN IF time < 0
        THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid state!';
    END IF;
END;
# 3
insert into Band(name) select distinct Name from Chinook.Artist join Chinook.Album on Artist.ArtistId = Album.ArtistId where AlbumId in (select AlbumId from Chinook.Track inner join Chinook.Genre on Track.GenreId = Genre.GenreId where Genre.Name!='Science Fiction' and Genre.Name!='TV Shows' and Genre.Name!='Sci Fi & Fantasy' and Genre.Name!='Drama' and Genre.Name!='Comedy');
insert into Album select distinct Album.Title, group_concat(distinct Genre.Name), ArtistId from Chinook.Track inner join Chinook.Genre on Track.GenreId = Genre.GenreId inner join Chinook.Album on Track.AlbumId = Album.AlbumId where Genre.Name!='Science Fiction' and Genre.Name!='TV Shows' and Genre.Name!='Sci Fi & Fantasy' and Genre.Name!='Drama' and Genre.Name!='Comedy' group by Chinook.Album.Title, Chinook.Album.ArtistId;
insert into Music.Track(title, time, album) select Track.Name, Milliseconds/1000, Album.Title from Chinook.Track inner join Chinook.Album on Track.AlbumId = Album.AlbumId inner join Chinook.Artist on Album.ArtistId = Artist.ArtistId inner join Chinook.Genre on Track.GenreId = Genre.GenreId where Genre.Name!='Science Fiction' and Genre.Name!='TV Shows' and Genre.Name!='Sci Fi & Fantasy' and Genre.Name!='Drama' and Genre.Name!='Comedy';

SET FOREIGN_KEY_CHECKS=0;
update Track inner join Album on Track.album = Album.title set Track.band=Album.band;
# 4
delimiter //
create procedure countAlbums()
begin
    CREATE TEMPORARY TABLE TempTable (band int, amount int);
    INSERT INTO TempTable select band, count(title) amount from Album inner join Band on band=id group by band;
    select * from TempTable;
    update Band inner join TempTable on id=band set albumsAmount=amount where id=band;
    DROP TABLE TempTable;
end;//
drop procedure countAlbums;
call countAlbums;
# 5
create trigger updateAlbumsAmountOnInsert after insert on Album
for each row
begin
    update Band set albumsAmount=albumsAmount+1 where id=new.band;
end;

create trigger updateAlbumsAmountOnDelete after delete on Album
for each row
begin
    update Band set albumsAmount=albumsAmount-1 where id=old.band;
end;
# 6
create procedure checkGenres()
begin
    create temporary table temp(genre varchar(30));
    insert into temp select distinct genre into @genres from Album where genre not in (select Name from Chinook.Genre);
    update Album set genre=(select Name from Chinook.Genre group by GenreId having min(GenreId) limit 1) where genre in (select genre from temp);
    drop table temp;
end; //
drop procedure checkGenres;
call checkGenres();
# 7
create procedure insertAlbums(in num int)
begin
    declare cnt int unsigned default 0;
    while cnt < num do
        set @songsCnt = 0;
        set @songs = (select floor( rand() * (20-6) + 6));
        set @albumName = (select floor( rand() * (200-60) + 60));
        set @bandName = (select floor(rand() * (select count(*) from Band)));
        insert into Album select @albumName, (select floor( rand() * (20-1) + 1)), @bandName;
        while @songsCnt < @songs do
            insert into Track(title, time, album, band) select (@songsCnt+1), (select floor( rand() * (401-1) + 1)), @albumName, @bandName;
            set @songsCnt = @songsCnt + 1;
        end while;
        set cnt = cnt + 1;
    end while;
end; //

drop procedure insertAlbums;
call insertAlbums(3);

# 8
create procedure longestAlbumTitle()
begin
    select distinct Album.band, title from Album inner join (select band, max(length(title)) maxlen from Album group by band) bm where length(title)=maxlen and Album.band=bm.band;
end;//
drop procedure longestAlbumTitle;
call longestAlbumTitle;
# 9
CREATE VIEW bandView
AS
SELECT
    Band.Name,
    group_concat(Album.title) albums,
    group_concat(Album.genre) genres
FROM
    Album
INNER JOIN
    Band group by Band.Name;
drop view bandView;
select * from bandView;
# 10
create trigger updateAlbumsAmountAfterDelete after delete on Album
for each row
begin
    update Band set albumsAmount=albumsAmount-1 where id=old.band;
    delete from Track where album=old.title;
end;
# 11
SET FOREIGN_KEY_CHECKS=0;
create procedure deleteAlbumsWithPattern(
    in pattern varchar(30))
begin
    if length(pattern) > 0
    then
        set @stmt = concat('delete from Album where title like (''%', pattern, '%'')');
        prepare st from @stmt;
        execute st;
        deallocate prepare st;
    end if;
end;//
drop procedure deleteAlbumsWithPattern;
call deleteAlbumsWithPattern('patt');
# 12
create index idxGenre on Album(genre);
# 13
create view trackTimeBand
as
    select Band.name, count(title) amount
    from Track
    inner join Band on Track.band = Band.id
    where time>120
    group by band;
drop view trackTimeBand;
select * from trackTimeBand;
# 14
prepare showTracks from 'select Track.title from Track inner join Band on Track.band = Band.id inner join Album on Track.album = Album.title where Band.name=? and Album.genre=?';
set @a = 'AC/DC';
set @b = 'Rock';
execute showTracks using @a, @b;
# 15
prepare longestTrack from 'select Album.title, group_concat(Track.title) LongestTitles from Track inner join Album on Track.album = Album.title inner join Band on Track.band = Band.id where Album.genre=? and time < ? and length(Track.title)=(select max(length(Track.title)) from Track where Track.band=Band.id) group by Album.title';
set @a = 'Rock';
set @b = 300;
execute longestTrack using @a, @b;
# 16
create procedure proc(
    in tbl varchar(30),
    in col varchar(30))
begin
    set @st = concat('select ', col, ' from ', tbl, ' order by ', col, ' desc limit 1 ');
    prepare stmt from @st;
    execute stmt;
    deallocate prepare stmt;
end //

drop procedure proc;
call proc('Band', 'name');
# 17

# 18

# 19
SHOW TRIGGERS;
# 20
SELECT user FROM mysql.user;
show grants;










