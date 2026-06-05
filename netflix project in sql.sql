DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

select * from netflix;


select
     count(*) as total_content
from netflix;

select
     distinct type
from netflix;

select * from netflix

-- 15 business problems
--1. Count the number of Movies vs TV Shows
select 
     type,
	 count(*) as total_content
from netflix
group by type

--2. Find the most common rating for movies and TV shows
select
      type,
	  rating
from
(
select 
      type,
	  rating,
	  count(*),
	  rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
) as t1
where
     ranking=1
--order by 3 desc

--3. List all movies released in a specific year (e.g., 2020)
--filter 2020
--movies

SELECT * FROM netflix
WHERE
     type = 'Movie'
	 AND
   release_year = 2020

--4. Find the top 5 countries with the most content on Netflix

SELECT
      unnest (string_to_array(country,',')) as new_country,
	  count(show_id) as total_content
FROM netflix
group by 1
order by 2 desc
limit 5
--5. Identify the longest movie

select * from netflix
where
    type ='ovie'
	and 
	duration =(select max(duration)from netflix)
	
--6. Find content added in the last 5 years

select 
     *
from netflix
where
    to_date(date_added,'month dd,YYYY') >= current_date - interval '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons

select * from netflix
where
     type = 'tv show'
	 and
     split_part(duration,'',1)::numeric > 5 
	 
9. Count the number of content items in each genre

select 
      UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	  COUNT(show_id) AS total_content
from netflix
group by 1

--10.Find each year and the average numbers of content release in India on netflix. 
  --return top 5 year with highest avg content release!

select 
    extract(year from TO_DATE(Date_added, 'MONTH DD, YYYY')) as year,
	count(*),
	count(*)::numeric/(select count(*) from netflix where country = 'india')::numeric * 100 as avg_content_per_year
from netflix
where country ='india'
group by 1

--11. List all movies that are documentaries

select *from netflix
where
listed_in LIKE '%Documentaries%'

--12. Find all content without a director

select * from netflix
where 
    director is null
	
--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 
    casts Ilike '%Salman khan%'
	and 
	release_year > extract(year from current_date) -10
	
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
--show_id,
--casts,
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country Ilike '%india%'
group by 1
order by 2 desc

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.
with new_table
as(
select 
*,
   case
   when description Ilike '%kill%' or
         description Ilike '%violence%' then 'bad_content'
		 else 'good content'
	  end category
from netflix
)
select
     category,
	 count(*) as total_content
from new_table
group by 1

where
    description Ilike '%kill%'
	or
	description Ilike '%violence%'
	