set search_path to pagila;

-- 1. Find films at least 2-hour long
select *
from film
where length >= 120;

-- 2. Find the id and description of the film 'ACADEMY DINOSAUR'
select film_id, description
from film
where title = 'ACADEMY DINOSAUR';

select film_id, description
from film
where title ILIKE 'ACADEMY DINOSAUr';

select film_id, description, title
from film
where title ILIKE '%academy%';

-- 3. Find the categories of 'ACADEMY DINOSAUR'

select c.name
from film f
         inner join film_category fc on f.film_id = fc.film_id
         inner join category c on c.category_id = fc.category_id
where title = 'ACADEMY DINOSAUR';

-- 4. Find the films without categories

select *
from film f
         left join film_category fc on f.film_id = fc.film_id
where fc.category_id is null;

-- 5. Find the categories without films

-- 6. Find the 'Action' films
select *
from film f
         inner join film_category fc on f.film_id = fc.film_id
         inner join category c on c.category_id = fc.category_id
where name = 'Action';

-- not good, cheating
select *
from film f
         inner join film_category fc on f.film_id = fc.film_id
where category_id = 1;

-- 7. Find the number of films in the 'Action' category
select count(*) as n_films
from category c
         inner join film_category fc on c.category_id = fc.category_id
where name = 'Action';

-- 8. Number of films in each category

select category_id, count(film_id) as n_films
from film_category
group by category_id
order by n_films desc;

select c.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id, name
order by n_films desc;

-- not valid in all DBMS
select c.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id
order by n_films desc;

-- not going to work
select fc.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by fc.category_id
order by n_films desc;

-- 9. Find the number of categories for each film

select f.film_id, title, count(category_id) as n_categories
from film_category fc
         right join film f on f.film_id = fc.film_id
group by f.film_id, title
order by n_categories;


-- 10. Find the number of films

select count(*) as n_films
from film;

-- 11. Find the number of different languages in the language table

select count(language_id) as n_languages
from language;

-- 12. Find the number of different languages in the film table

select count(distinct language_id) as n_languages
from film;

-- 13. Find the categories without films

-- 14. Find the category with the largest number of films

select c.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id, name
order by n_films desc
LIMIT 1;

select c.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id, name
having count(film_id) = 74;

select c.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id, name
order by n_films desc;

select max(n_films)
from (select count(film_id) as n_films
      from film_category fc
               right join category c on c.category_id = fc.category_id
      group by c.category_id, name) as temp;

select c.category_id, name as category_name, count(film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id, name
having count(film_id) = (select max(n_films)
                         from (select count(film_id) as n_films
                               from film_category fc
                                        right join category c on c.category_id = fc.category_id
                               group by c.category_id, name) as temp);