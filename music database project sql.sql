--select * from music_database.dbo.album$;
--select * from music_database.dbo.album2$;
--select * from music_database.dbo.artist$;
--select * from music_database.dbo.customer$;

--EASY QUESTIONS::
--Ques 1:- who is the senior most employee in the job title?
select * from music_database.dbo.employee$ order by levels desc 

--Ques 2:- which country has the most invoices?
select count(billing_country) as counting,billing_country from music_database.dbo.invoice$ group by billing_country 
order by counting desc;

--Ques 3:- what are the top three values of total invoices?
select total from music_database.dbo.invoice$ order by total desc;

--Ques 4:-Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--       Write a query that returns one city that has the highest sum of invoice totals. 
--       Return both the city name & sum of all invoice totals
select billing_city,SUM(total) as invoice_total from music_database.dbo.invoice$ group by billing_city order by invoice_total desc;

--Ques 5:-Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--        Write a query that returns the person who has spent the most money.
select a.customer_id, a.first_name,a.last_name,SUM(total) as t from music_database.dbo.customer$ as a 
join music_database.dbo.invoice$ as b on a.customer_id=b.customer_id group by a.customer_id,a.first_name,a.last_name order by t desc;


--MODERATE QUESTIONS::
--Ques 1:- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--         Return your list ordered alphabetically by email starting with A.
select distinct email,last_name,first_name from music_database.dbo.customer$ as a join music_database.dbo.invoice$ as b 
on b.customer_id=a.customer_id join music_database.dbo.invoice_line$ as c on c.invoice_id=b.invoice_id 
where track_id in( select track_id from music_database.dbo.track$ as d join music_database.dbo.genre$ as e on d.genre_id = e.genre_id  
where e.name like 'Rock')
order by email

--Ques 2:-Let's invite the artists who have written the most rock music in our dataset. 
--        Write a query that returns the Artist name and total track count of the top 10 rock bands.
select a.name,a.artist_id,count(a.artist_id) as t from music_database.dbo.artist$ as a 
join music_database.dbo.album$ as b on a.artist_id= b.artist_id 
join music_database.dbo.track$ as c on c.album_id=b.album_id 
join music_database.dbo.genre$ as d on d.genre_id= c.genre_id
where d.name like 'Rock'
group by a.artist_id,a.name order by t desc

--Ques 3:-Return all the track names that have a song length longer than the average song length. 
--        Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
select name,milliseconds from music_database.dbo.track$ 
where milliseconds>(select avg(milliseconds) as avg_length_track from music_database.dbo.track$)
order by milliseconds desc;


--Advance Questions::
--Ques 1:-Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
WITH best_selling_artist AS (
	SELECT music_database.dbo.artist$.artist_id AS artist_id, music_database.dbo.artist$.name AS artist_name, 
	SUM(music_database.dbo.invoice_line$.unit_price*music_database.dbo.invoice_line$.quantity) AS total_sales
	FROM music_database.dbo.invoice_line$
	JOIN music_database.dbo.track$ tt ON tt.track_id = music_database.dbo.invoice_line$.track_id
	JOIN music_database.dbo.album$ a ON a.album_id = tt.album_id
	JOIN music_database.dbo.artist$ ON music_database.dbo.artist$.artist_id = a.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM music_database.dbo.invoice$ i
JOIN music_database.dbo.customer$ c ON c.customer_id = i.customer_id
JOIN music_database.dbo.invoice_line$ il ON il.invoice_id = i.invoice_id
JOIN music_database.dbo.track$ t ON t.track_id = il.track_id
JOIN music_database.dbo.album$ alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;