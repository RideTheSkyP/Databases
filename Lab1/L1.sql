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
select ArtistId from Artist where Name="Within Temptation";
