set search_path to pagila;

-- 1. Find films at least 2-hour long
select film_id, title, description, length
from film
where length >= 120;

-- 2. Find the id and description of the film 'ACADEMY DINOSAUR'

select film_id, description
from film
where title = 'ACADEMY DINOSAUR';

select film_id, description
from film
where title ilike '%ACADEMY%DINOSAUR%';

-- 3. Find the categories of 'ACADEMY DINOSAUR'

select f.film_id,
       f.title as movie_title,
       c.category_id,
       c.name  as category_name
from film f
         inner join film_category fc on f.film_id = fc.film_id
         inner join category c on c.category_id = fc.category_id
where title ilike '%ACADEMY%DINOSAUR%';

-- 4. Find the films without categories

-- select f.film_id, fc.film_id, fc.category_id
select f.title
from film f
         left join film_category fc on f.film_id = fc.film_id
where category_id is null;

-- 5. Find the categories without films

select c.category_id, name
from category c
         left join film_category fc on c.category_id = fc.category_id
where fc.film_id is null;

-- 6. Find the 'Action' films

select f.film_id,
       f.title as movie_title,
       c.category_id,
       c.name  as category_name
from film f
         inner join film_category fc on f.film_id = fc.film_id
         inner join category c on c.category_id = fc.category_id
where c.name ilike '%Action%';

-- 7. Find the number of films in the 'Action' category

select count(*)
from film_category fc
         inner join category c on c.category_id = fc.category_id
where c.name ilike '%Action%';

-- 8. Number of films in each category

select category_id, count(film_id) as n_films
from film_category
group by category_id;

select c.category_id, name, count(film_id) as n_films
from film_category fc inner join category c on c.category_id = fc.category_id
group by c.category_id, name
order by n_films desc;

select c.category_id, name, count(film_id) as n_films
from film_category fc right join category c on c.category_id = fc.category_id
group by c.category_id, name
order by n_films desc;

-- 9. Find the number of categories for each film

select f.film_id, f.title, count(category_id) as n_categories
from film_category fc right join film f on f.film_id = fc.film_id
group by f.film_id, f.title
order by n_categories;

-- 10. Find the number of films

-- 11. Find the number of different languages in the language table

-- 12. Find the number of different languages in the film table

-- 13. Find the categories without films

-- 14. category with the largest number of films