SQL PROJECT  QUESTION 1:
We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children,
Classics, Comedy, Family and Music. Create a query that lists each movie,
the film category it is classified in, and the number of times it has been rented out.

CODE :

WITH t1 AS (SELECT f.title AS titre_film, c.name AS category_name 
	    FROM film f JOIN film_category fc ON fc.film_id = f.film_id 
	    JOIN category c 
	    ON c.category_id=fc.category_id 
	    JOIN inventory i ON i.film_id=f.film_id 
	    JOIN rental r ON r.inventory_id = i.inventory_id 
	    WHERE c.name IN ('Animation','Children', 'Classics', 'Comedy', 'Family','Music') )  
	    SELECT titre_film,        category_name, 	   
	    COUNT(*) rental_count FROM t1 GROUP BY 1,2 ORDER BY 2,1   

QUESTION 2 :

Now we need to know how the length of rental duration of these family-friendly movies compares to the duration
that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels 
(first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) 
of the rental duration for movies across all categories? Make sure to also indicate the category that these
family-friendly movies fall into.  

CODE :  
WITH t1 AS (SELECT f.title AS titre_film, c.name AS category_name, f.rental_duration 
	    FROM film f 
	    JOIN film_category fc 
	    ON fc.film_id = f.film_id 
	    JOIN category c 
	    ON c.category_id=fc.category_id 
	    JOIN inventory i ON i.film_id=f.film_id 
	    JOIN rental r ON r.inventory_id = i.inventory_id 
	    WHERE c.name IN ('Animation','Children', 'Classics', 'Comedy', 'Family','Music'))  
SELECT titre_film, category_name, rental_duration, NTILE(4) OVER (ORDER BY rental_duration) FROM t1  
			     
QUESTION 3:
			     
Finally, provide a table with the family-friendly film category, each of the quartiles,
and the corresponding count of movies within each combination of film category for each
corresponding rental duration category. The resulting table should have three columns:
	•	Category 	•	Rental length category 	•	Count
 
CODE :
			     
WITH t1 AS (SELECT f.title AS title_film, c.name AS category_name, f.rental_duration 
	    FROM film f 
	    JOIN film_category fc ON fc.film_id = f.film_id 
	    JOIN category c ON c.category_id=fc.category_id 
	    JOIN inventory i ON i.film_id=f.film_id 
	    JOIN rental r ON r.inventory_id = i.inventory_id 
	    WHERE c.name IN ('Animation','Children', 'Classics', 'Comedy', 'Family','Music')),  
			     t2 AS( 
			SELECT title_film, category_name, rental_duration, NTILE(4) 
		        OVER (ORDER BY rental_duration) as quartile FROM t1)  SELECT   category_name, quartile, COUNT(*) AS nbre 
			FROM t2 GROUP bY 1,2 ORDER BY 1,2  
			     
QUESTION 4:

We want to find out how the two stores compare in their count of rental orders during every month for
all the years we have data for. Write a query that returns the store ID for the store, the year and month and
the number of rental orders each store has fulfilled for that month. Your table should include a column for each 
of the following: year, month, store ID and count of rental orders fulfilled during that month.  
		
CODE :
			     
WITH t1 AS (SELECT c.store_id, r.rental_date, r.rental_id 
	    FROM customer c      
	    JOIN rental r      
	    ON r.customer_id = c.customer_id)       
			     SELECT EXTRACT(year FROM rental_date) AS year, EXTRACT(month FROM rental_date) AS month, store_id, COUNT(*)       
			     FROM t1      
			     GROUP BY 3, 2, 1 	 
			     ORDER BY 4 DESC
