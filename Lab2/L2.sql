# 1
create user 'user'@'localhost' identified by 'password';
grant select, update, insert on Music to 'user'@'localhost';
create database Music;
use Music;
# 2
create table Band(  id int unsigned auto_increment primary key,
                    name varchar(90),
                    albumsAmount int null);
create table Album( title varchar(160),
                    genre varchar(30),
                    band int,
                    primary key (title, band));
create table Track( id int unsigned auto_increment primary key,
                    title varchar(160),
                    time int unsigned,
                    album varchar(160),
                    band int unsigned,
                    index(album), foreign key(album) references Album(title),
                    index(band), foreign key(band) references Band(id)) AUTO_INCREMENT=1;
# 3
insert into Band(name) select distinct Name from Chinook.Artist join Chinook.Album on Artist.ArtistId = Album.ArtistId where AlbumId in (select AlbumId from Chinook.Track inner join Chinook.Genre on Track.GenreId = Genre.GenreId where Genre.Name!="Science Fiction" and Genre.Name!="TV Shows" and Genre.Name!="Sci Fi & Fantasy" and Genre.Name!="Drama" and Genre.Name!="Comedy");
insert into Album select distinct Album.Title, group_concat(distinct Genre.Name), ArtistId from Chinook.Track inner join Chinook.Genre on Track.GenreId = Genre.GenreId inner join Chinook.Album on Track.AlbumId = Album.AlbumId where Genre.Name!="Science Fiction" and Genre.Name!="TV Shows" and Genre.Name!="Sci Fi & Fantasy" and Genre.Name!="Drama" and Genre.Name!="Comedy" group by Chinook.Album.Title, Chinook.Album.ArtistId;
insert into Music.Track(title, time, album) select Track.Name, Milliseconds/1000, Album.Title from Chinook.Track inner join Chinook.Album on Track.AlbumId = Album.AlbumId inner join Chinook.Artist on Album.ArtistId = Artist.ArtistId inner join Chinook.Genre on Track.GenreId = Genre.GenreId where Genre.Name!="Science Fiction" and Genre.Name!="TV Shows" and Genre.Name!="Sci Fi & Fantasy" and Genre.Name!="Drama" and Genre.Name!="Comedy";
