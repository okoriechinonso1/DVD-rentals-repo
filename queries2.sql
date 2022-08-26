/*Project 1 Question 3*/
with subquery as (select c.name as category, f.title as film_title, ntile(4) over (partition by f.rental_duration) as standard_quartile
					from film f
					join film_category fc
					on f.film_id = fc.film_id
					join category c
					on fc.category_id = c.category_id
					where c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
					order by 1, 2)
					
select category, standard_quartile, count(*) as count_of_movies
from subquery
group by 1, 2
order by 1, 2;

/*PROJECT QUESTION SET #2*/
/*Question 1*/
with t1 as (select r.rental_date, s.store_id
			from store s
			join staff st
			on s.store_id = st.store_id
			join payment p
			on p.staff_id = st.staff_id
			join rental r
			on p.rental_id = r.rental_id)
			
select date_part('year', t1.rental_date) as rental_year, date_part('month', t1.rental_date) as rental_month, t1.store_id,
		count(*) as count_rentals
from t1
group by 2, 1, 3
order by 4 desc;

/*QUESTION 2*/
(select t1.first_name || ' ' || t1.last_name as full_name, t1.pay_month, t1.count_of_payment, t1.pay_per_month
from (select c.first_name, c.last_name, date_trunc('month', p.payment_date) as pay_month, count(*) as count_of_payment,
	sum(amount) as pay_per_month
	from customer c
	join payment p
	on c.customer_id = p.customer_id
	group by 1, 2, 3
	order by 5 desc) t1
where t1.first_name || ' ' || t1.last_name in (select full_name
											  from (select first_name || ' ' || last_name as full_name, count(*) as count_of_payment
													  from customer c
													  join payment p
													  on c.customer_id = p.customer_id
													  group by 1
													  order by 2 desc
													  limit 10) t2)
order by 1, 2);

/*QUESTION 3*/


with t3 as (select t1.first_name || ' ' || t1.last_name as full_name, t1.pay_month, t1.count_of_payment, t1.pay_per_month
			  from (select c.first_name, c.last_name, date_trunc('month', p.payment_date) as pay_month, count(*) as count_of_payment,
					sum(amount) as pay_per_month
					from customer c
					join payment p
					on c.customer_id = p.customer_id
					group by 1, 2, 3
					order by 5 desc) t1
			  where t1.first_name || ' ' || t1.last_name in (select full_name
															  from (select first_name || ' ' || last_name as full_name, 
																		   count(*) as count_of_payment
																	  from customer c
																	  join payment p
																	  on c.customer_id = p.customer_id
																	  group by 1
																	  order by 2 desc
																	  limit 10) t2)
			  order by 1, 2)

select full_name, pay_month, pay_per_month,
	   coalesce(lead(pay_per_month) over(partition by full_name order by pay_per_month), 0) as lead_pay_per_month,
	   coalesce(lead(pay_per_month) over(partition by full_name order by pay_per_month) - pay_per_month, 0) as monthly_pay_diff
from t3;




