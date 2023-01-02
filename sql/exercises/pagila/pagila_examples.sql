set search_path to pagila;

-- 1. Find films at least 2-hour long
select film_id, title, length
from film
where length >= 120
order by length desc;

-- 2. Find the id and description of the film 'ACADEMY DINOSAUR'
select film_id, description
from film
where title = 'ACADEMY DINOSAUR';

-- 3. Find the categories of 'ACADEMY DINOSAUR'
select c.name
from film f
         inner join film_category fc on f.film_id = fc.film_id
         inner join category c on c.category_id = fc.category_id
where title = 'ACADEMY DINOSAUR';

-- 4. Find the films without categories
select f.film_id, title
from film f
         left join film_category fc on f.film_id = fc.film_id
where category_id is null;

-- 5. Find the categories without films
select c.category_id, c.name
from category c
         left join film_category fc on c.category_id = fc.category_id
where film_id is null;

-- 6. Find the 'Action' films
select f.film_id, f.title
from category c
         inner join film_category fc on c.category_id = fc.category_id
         inner join film f on f.film_id = fc.film_id
where c.name ilike 'action';
-- where c.name = 'Action';

-- 7. Find the number of films in the 'Action' category
select count(f.film_id)
from category c
         inner join film_category fc on c.category_id = fc.category_id
         inner join film f on f.film_id = fc.film_id
where c.name = 'Action';

-- join with film not necessary
select count(fc.film_id) as "number of films"
from category c
         inner join film_category fc on c.category_id = fc.category_id
where c.name = 'Action';

-- 8. Number of films in each category
select fc.category_id, count(fc.film_id) as n_films
from film_category fc
group by fc.category_id;

-- to get the category names, we need a join with category
select fc.category_id, c.name, count(fc.film_id) as n_films
from film_category fc
         inner join category c on c.category_id = fc.category_id
group by fc.category_id, c.name;

-- what about the categories without movies?

select c.category_id, c.name, count(fc.film_id) as n_films
from film_category fc
         right join category c on c.category_id = fc.category_id
group by c.category_id, c.name;

-- 9. Find the number of categories for each film
select fc.film_id, count(fc.category_id) as n_categories
from film_category fc
group by fc.film_id;

-- join with film to get to get the titles
select fc.film_id, f.title, count(fc.category_id) as n_categories
from film_category fc
         inner join film f on fc.film_id = f.film_id
group by fc.film_id, f.title;

-- films without categories?
select f.film_id, f.title, count(fc.category_id) as n_categories
from film f
         left join film_category fc on f.film_id = fc.film_id
group by f.film_id, f.title;

-- 10. Find the number of films
select count(film_id) as n_films
from film;

select count(*) n_films
from film;

-- incorrect because of null values in original_language_id
select count(original_language_id) n_films
from film;

-- 11. Find the number of different languages in the language table
select count(language_id) as n_languages
from language;

select count(distinct language_id) as n_languages
from language;

-- 12. Find the number of different languages in the film table
select count(language_id) as n_languages
from film;

select count(distinct language_id) as n_languages
from film;


-- multiple versions of the same queries

-- 13. Find the categories without films

--  with a left join
select c.category_id, c.name
from category c
         left join film_category fc on c.category_id = fc.category_id
where film_id is null;

-- with a group by
select c.category_id, c.name
from category c
         left join film_category fc on c.category_id = fc.category_id
group by c.category_id, c.name
having count(fc.film_id) = 0;

-- with a not in (non-correlated sub query)
select category_id, name
from category
where category_id not in (select category_id from film_category);

-- with a not exists (correlated sub-query) (optional)
select category_id, name
from category c
where not exists(select fc.category_id
                 from film_category fc
                 where fc.category_id = c.category_id);

-- with except
select category_id, name
from category c
except
select c.category_id, c.name
from category c
         inner join film_category fc on fc.category_id = c.category_id;

-- with except in a non-correlated sub-query inside the from
select c.category_id, name
from category c
         inner join (select category_id
                     from category c
                     except
                     select fc.category_id
                     from film_category fc) as T
                    on c.category_id = T.category_id;

-- with except in a non-correlated sub-query inside the with
with T as (select category_id
           from category c
           except
           select fc.category_id
           from film_category fc)
select c.category_id, name
from category c
         inner join T on c.category_id = T.category_id;


-- 14. category with the largest number of films
select fc.category_id,
       count(fc.film_id) as n_films
from film_category fc
group by fc.category_id
order by n_films desc
limit 1;

-- what if there were many categories with the same largest number of films?
select fc.category_id,
       count(fc.film_id) as n_films
from film_category fc
group by fc.category_id
order by n_films desc;

-- Find the largest number of films in a category

-- sub-query in the from

select max(n_films) as max
from (select count(fc.film_id) as n_films
      from film_category fc
      group by fc.category_id) as n_films_per_category;

-- with a sub-query in the with

with n_films_per_category
         as (select count(fc.film_id) as n_films
             from film_category fc
             group by fc.category_id)
select max(n_films) as max
from n_films_per_category;

-- Find the categories with the largest number of films in one category

-- a sub-query in the with, the other in the where

with n_films_per_category
         as (select fc.category_id, count(fc.film_id) as n_films
             from film_category fc
             group by fc.category_id)
select category_id, n_films
from n_films_per_category
where n_films = (select max(n_films) as max
                  from n_films_per_category);

-- 2 sub-queries in the with

with n_films_per_category
         as (select fc.category_id, count(fc.film_id) as n_films
             from film_category fc
             group by fc.category_id),
     max_n_films as (select max(n_films) as max
                      from n_films_per_category)
select category_id, n_films
from n_films_per_category
where n_films = (select * from max_n_films);

-- add the category name to the category_id

with n_films_per_category
         as (select fc.category_id, count(fc.film_id) as n_films
             from film_category fc
             group by fc.category_id)
select c.category_id, c.name, n_films
from n_films_per_category n
         inner join category c on n.category_id = c.category_id
where n_films = (select max(n_films) as max
                  from n_films_per_category);

-- do you find this query beautiful?