# 1
show tables from sakila;
# 2
select title from film where length > 120;
# 3
select title, l.name
from film
    inner join language l on film.language_id = l.language_id
where description like '%Documentary%';
# 4
select f.title from film as f
    inner join film_category as fc on f.film_id = fc.film_id
    inner join category as c on fc.category_id = c.category_id
    where c.name ='Documentary' and f.description not like '%Documentary%';
# 5
select distinct concat(a.first_name, ' ', a.last_name) from actor as a
    inner join film_actor as fa on a.actor_id = fa.actor_id
    inner join film as f on fa.film_id = f.film_id
    where f.special_features like '%Deleted Scenes%';
# 6
select rating, count(title) as amount from film group by rating;
# 7
select distinct title from film as f
    inner join inventory as i on f.film_id = i.film_id
    inner join rental as r on i.inventory_id = r.inventory_id
    where date(rental_date) between '2005-05-25' and '2005-05-30' order by title;
# 8
select title from film as f where rating='R' order by length desc limit 5;
# 9
select first_name, last_name from customer where customer_id in (select distinct p1.customer_id from payment p1 join payment p2 where p1.customer_id=p2.customer_id and p1.staff_id<>p2.staff_id);
# 10
select concat(first_name, ' ', last_name)
from (select c.customer_id as ci, count(*) as cnt from customer as c
      inner join rental r on c.customer_id = r.customer_id group by c.customer_id) as cc
      inner join customer on customer_id=ci
      where cnt > (select count(*) from customer as c
            inner join rental r on c.customer_id = r.customer_id
            where email='PETER.MENARD@sakilacustomer.org');
# 11
select concat(a1.first_name, ' ', a1.last_name), concat(a2.first_name, ' ', a2.last_name) from
((select first_name, last_name, fa.film_id, actor.actor_id from actor inner join film_actor fa on actor.actor_id = fa.actor_id inner join film f on fa.film_id = f.film_id) as a1 inner join
(select first_name, last_name, fa.film_id, actor.actor_id from actor inner join film_actor fa on actor.actor_id = fa.actor_id inner join film f on fa.film_id = f.film_id) as a2)
where a1.film_id=a2.film_id and a1.actor_id>a2.actor_id group by a1.actor_id, a2.actor_id having count(concat(a1.actor_id, a2.actor_id)) > 2;
# 12
select distinct concat(first_name, ' ', last_name)
from actor
where actor_id not in (select distinct actor_id
                       from film_actor
                       where film_id in (select film.film_id from film where title like 'B%'));

# 13
select concat(a.first_name, ' ', a.last_name)
from actor as a
    inner join film_actor fa on a.actor_id = fa.actor_id
    inner join film_category fc on fa.film_id = fc.film_id
    inner join category c on fc.category_id = c.category_id
group by a.actor_id
having sum(c.name='Horror') > sum(c.name='Action');
# 14
select concat(first_name, ' ', last_name)
from customer as c
where
      (select avg(amount)
      from payment as p
      where p.customer_id=c.customer_id
      group by customer_id) > (select avg(amount)
                               from payment
                               where date(payment_date)='2005-07-07');
# 15
alter table language add films_no int default 0;
update language
set films_no=(select cnt
              from (select l.language_id as lId,
                          count(film_id) as cnt
                    from film
                    right join language l on film.language_id = l.language_id
                    group by l.language_id) as fl
                    where lId=language_id);
# 16
SELECT * from film where title='WON DARES';
update film
set language_id=(select language_id
                 from language
                 where name='Mandarin')
                 where title='WON DARES';

update film
set language_id=(select language_id
                 from language
                 where name='German')
                 where film_id in (select film_id
                      from actor
                      inner join film_actor on actor.actor_id = film_actor.actor_id
                      where first_name='NICK' and last_name='WAHLBERG');
# 17
alter table film drop release_year;
