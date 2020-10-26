# 1
show tables;
# 2
describe Track;
# 3
select Name, Title from Artist join Album on Artist.ArtistId = Album.ArtistId;
# 4
select Title from Album where ArtistId=(select ArtistId from Artist where Name="Various Artists");
# 5
select Name from Track where Milliseconds>250000;
# 6
select Name from Track where Milliseconds between 152000 and 2583000;
# 7
select Track.Name, Album.Title, Artist.Name, Genre.Name from Track
    join Album on Album.AlbumId = Track.AlbumId
    join Artist on Artist.ArtistId = Album.ArtistId
    join Genre on Genre.GenreId = Track.GenreId
    where TrackId in (select TrackId from PlaylistTrack where PlaylistId=(select PlaylistId from Playlist where Name="90’s Music"));
# 8
select FirstName, LastName from Customer where Country="Germany";
# 9
select City, State from Customer where PostalCode is not null;
# 10
select Artist.Name, count(*) as AlbumsAmount from Album
    join Artist on Artist.ArtistId = Album.ArtistId
    group by Album.ArtistId;
# 11
select BillingCity, sum(Total) sum from Invoice group by BillingCity order by sum desc limit 1;
# 12
select BillingCountry, avg(Total) Average from Invoice group by BillingCountry;
# 13
select FirstName, LastName from Employee where EmployeeId not in (select distinct SupportRepId from Customer);
# 14
select distinct Employee.FirstName, Employee.LastName from Customer
    join Employee on Employee.EmployeeId = Customer.SupportRepId
        where Customer.City != Employee.City;
# 15
select Artist.Name, Album.Title, count(*) amount, sum(UnitPrice) from Track
    join Album on Album.AlbumId = Track.AlbumId
    join Artist on Artist.ArtistId = Album.ArtistId
    group by Artist.Name, Album.Title
    order by amount desc;
# 16
select Name, UnitPrice from Track where GenreId in (select GenreId from Genre where Name="Sci Fi & Fantasy" or Name="Science Fiction");
# 17
select Artist.Name, count(*) amount from Track
    join Album on Album.AlbumId = Track.AlbumId
    join Artist on Artist.ArtistId = Album.ArtistId
        where GenreId in (select GenreId from Genre where Name="Metal" or Name="Heavy Metal")
    group by Artist.Name
    order by amount desc;
# 18
select Name from Track where Name like "%Battlestar Galactica%";
# 19
select Artist.Name, A1.Title, A1.ArtistId from Artist, Album A1, Album A2
    where A1.Title=A2.Title and A1.ArtistId != A2.ArtistId and Artist.ArtistId=A1.ArtistId;
# 20
select Track.Name from Track
    join Album on Album.AlbumId = Track.AlbumId
    join Artist on Artist.ArtistId = Album.ArtistId
        where Track.Composer like "%Santana%" or Artist.Name like "%Santana%";
# 21
select Artist.Name, avg(Milliseconds) Average from Track
    join Album on Album.AlbumId = Track.AlbumId
    join Artist on Artist.ArtistId = Album.ArtistId
    where Album.ArtistId in
        (select ArtistId
            from (select Artist.ArtistId, count(*) RockAmount from Track
                join Album on Track.AlbumId = Album.AlbumId
                join Artist on Artist.ArtistId = Album.ArtistId
                    where GenreId=(SELECT GenreId from Genre where Name="Rock")
                group by Artist.ArtistId having RockAmount>13) as AIRA)
    group by Artist.Name
    order by Average desc;
# 22
select substring_index(Email, "@", -1) Domain, count(*) Amount from Customer group by Domain;
# 23
insert into Customer values (60, "Leonard", "Hofstadter", null, null, null, null, null, null, null, null, "leonard.hofstadter@gmail.com", null);
# 24
alter table  Customer add FavGenre varchar(25);
# 25
update Customer set FavGenre=floor(rand() * (select distinct count(GenreId) from Genre) + 1) where FavGenre is null;
# 26
alter table Customer drop column Fax;
# 27
update Customer
set FavGenre = (select max(ciIg.genreId)
from (select iI.genreId genreId
      from (select cIc.customerId customerId,
                   max(cnt) counter
            from (select Invoice.CustomerId customerId,
                         count(invoices.genreId) cnt
                  from (select distinct InvoiceLine.InvoiceId invoiceId,
                                        genres.genreId genreId
                        from (select Track.TrackId trackId,
                                     Genre.GenreId genreId
                              from Track
                                   inner join Genre
                                        on Genre.GenreId = Track.GenreId) genres
                           inner join InvoiceLine
                                on genres.trackId = InvoiceLine.TrackId
                        order by invoiceId) invoices
                           inner join Invoice
                                on invoices.invoiceId = Invoice.InvoiceId
                  group by Invoice.CustomerId, invoices.genreId
                  order by Invoice.CustomerId) cIc
            group by cIc.customerId) c

            inner join (select Invoice.CustomerId customerId,
                               invoices.genreId genreId,
                               invoices.name name,
                               count(invoices.genreId) counter
                            from (select distinct InvoiceLine.InvoiceId invoiceId,
                                                  genres.genreId genreId,
                                                  genres.name name
                                from (select Track.TrackId trackId,
                                             Genre.GenreId genreId,
                                             Genre.Name name
                                        from Track
                                            inner join Genre
                                                on Genre.GenreId = Track.GenreId) genres
                                        inner join InvoiceLine
                                            on genres.trackId = InvoiceLine.TrackId
                                        order by InvoiceId) invoices
                                    inner join Invoice
                                        on invoices.invoiceId = Invoice.InvoiceId
                                group by Invoice.CustomerId, invoices.genreId
                                order by Invoice.CustomerId) iI
                                    on c.customerId = iI.customerId
                                where c.counter = iI.counter) ciIg);
# 28
SET FOREIGN_KEY_CHECKS=0;
delete from Invoice where year(InvoiceDate)<2010;
SET FOREIGN_KEY_CHECKS=1;
# 29
set @var = (select distinct CustomerId from Customer where CustomerId not in (select distinct CustomerId from Invoice));
delete from Customer where CustomerId = @var;
# 30
CREATE PROCEDURE add_track(
	in track varchar(255),
	in album varchar(255),
	in artist varchar(255),
 	in mediatype_id int,
	in genre varchar(255),
	in composer varchar(255),
	in milliseconds int,
	in bytes int,
	in unit_price int
)
adding_process: begin
	declare artist_id int default 0;
	declare album_id int default 0;
	declare track_id int default 0;
	declare genre_id int default 0;

	if artist not in (select Name from Artist) then
		set artist_id = (select max(ArtistId) from Artist) + 1;
		insert into Artist values (artist_id, artist);
	else
		set artist_id = (select ArtistId from Artist where Name = artist);
	end if;

	if album not in (select Title from Album) then
		set album_id = (select max(AlbumId) from Album) + 1;
		insert into Album values (album_id, album, artist_id);
	else
		set album_id = (select AlbumId from Album where Title = album);
	end if;

	if genre not in (select Name from Genre) then
		set genre_id = (select max(GenreId) from Genre) + 1;
		insert into Genre values (genre_id, genre);
	else
		set genre_id = (select GenreId from Genre where Name = genre);
	end if;

	if (track not in (select Name from Track where Name = track))
	and (album_id not in (select AlbumId from Track where Name = track)) then
		set track_id = (select max(TrackId) from Track) + 1;
		insert into Track values (track_id,
								  track,
								  album_id,
								  mediatype_id,
								  genre_id,
								  composer,
								  milliseconds,
								  bytes,
								  unit_price);
	else
		leave adding_process;
	end if;
end;

call add_track('Who Ever Said', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Superblood Wolfmoon', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Dance of the Clairvoyants', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Quick Escape', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Alright', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Seven O`Clock', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Never Destination', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Take the Long Way', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Buckle Up', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('Retrograde', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);
call add_track('River Cross', 'Gigaton', 'Pearl Jam', 2, 'Experimental rock', 'Vedder', 3212315, 1952902, 0.99);

call add_track('Why Not Me', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Shot in the Dark', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('In the Middle of the Night', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Faster', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Fire and Ice', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Iron', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Where Is the Edge', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Sinéad', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Sinéad', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Murder', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('A Demon`s Fate', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
call add_track('Stairway to the Skies', 'The Unforgiving', 'Within Temptation', 2, 'Symphonic metal', 'Sharon den AdelRobert Westerholt', 3212315, 1952902, 0.99);
