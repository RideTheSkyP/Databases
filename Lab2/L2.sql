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
insert into Band(name) select distinct Name from Chinook.Artist join Chinook.Album on Artist.ArtistId = Album.ArtistId where AlbumId in (select AlbumId from Chinook.Track inner join Chinook.Genre on Track.GenreId = Genre.GenreId where Genre.Name!="Science Fiction" and Genre.Name!="TV Shows" and Genre.Name!="Sci Fi & Fantasy" and Genre.Name!="Drama" and Genre.Name!="Comedy");
insert into Album select distinct Album.Title, group_concat(distinct Genre.Name), ArtistId from Chinook.Track inner join Chinook.Genre on Track.GenreId = Genre.GenreId inner join Chinook.Album on Track.AlbumId = Album.AlbumId where Genre.Name!="Science Fiction" and Genre.Name!="TV Shows" and Genre.Name!="Sci Fi & Fantasy" and Genre.Name!="Drama" and Genre.Name!="Comedy" group by Chinook.Album.Title, Chinook.Album.ArtistId;
insert into Music.Track(title, time, album) select Track.Name, Milliseconds/1000, Album.Title from Chinook.Track inner join Chinook.Album on Track.AlbumId = Album.AlbumId inner join Chinook.Artist on Album.ArtistId = Artist.ArtistId inner join Chinook.Genre on Track.GenreId = Genre.GenreId where Genre.Name!="Science Fiction" and Genre.Name!="TV Shows" and Genre.Name!="Sci Fi & Fantasy" and Genre.Name!="Drama" and Genre.Name!="Comedy";

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

