A. Aggregation & Grouping
-- select * from sh.customers

-- 1.Find the total, average, minimum, and maximum credit limit of all customers.

--select sum(cust_credit_limit) total,avg(cust_credit_limit) average,min(cust_credit_limit) minimum,max(cust_credit_limit) maximum from sh.customers

-- 2.Count the number of customers in each income level.

--select cust_income_level,count(*) from sh.customers group by cust_income_level

-- 3.Show total credit limit by state and country.

--select cust_state_province,cust_city,sum(cust_credit_limit) from sh.customers group by cust_state_province,cust_city 

-- 4.Display average credit limit for each marital status and gender combination.

--select cust_marital_status,cust_gender,avg(cust_credit_limit) from sh.customers group by cust_marital_status,cust_gender

-- 5.Find the top 3 states with the highest average credit limit.

--select cust_state_province,avg(cust_credit_limit) average_credit_limit from sh.customers group by cust_state_province order by average_credit_limit desc fetch first 3 rows only

--6.Find the country with the maximum total customer credit limit.

--select country_id,sum(cust_credit_limit) total_credit_limit from sh.customers group by country_id order by total_credit_limit desc fetch first 1 row only

-- 7.Show the number of customers whose credit limit exceeds their state average.

--SELECT COUNT(*) AS customers_above_state_avg
--FROM (
    --SELECT 
        --cust_credit_limit,
        --AVG(cust_credit_limit) OVER (PARTITION BY cust_state_province) AS state_avg
    --FROM sh.customers
--)
--WHERE cust_credit_limit > state_avg

-- 8.Calculate total and average credit limit for customers born after 1980.

--select sum(cust_credit_limit),avg(cust_credit_limit) from sh.customers where cust_year_of_birth > 1980

-- 9.Find states having more than 50 customers.

--select cust_state_province,count() from sh.customers group by cust_state_province having count() > 50

-- 10.List countries where the average credit limit is higher than the global average.

--select country_id,avg(cust_credit_limit) average from sh.customers
group by country_id having avg(cust_credit_limit) > ( select avg(cust_credit_limit) from sh.customers) order by average desc

-- 11.Calculate the variance and standard deviation of customer credit limits by country.

--select country_id,variance(cust_credit_limit),stddev(cust_credit_limit) from sh.customers group by country_id

-- 12.Find the state with the smallest range (max–min) in credit limits.

--select cust_state_province,max(cust_credit_limit) - min(cust_credit_limit) credit_limit_range from sh.customers group by cust_state_province order by credit_limit_range asc

--  13.Show the total number of customers per income level and the percentage contribution of each.

--select cust_income_level,count(*),
round(100.0*count()/sum(count()) over (),2) percentage_contribution from sh.customers group by cust_income_level order by count(*) desc

-- 14.For each income level, find how many customers have NULL credit limits.

--select cust_income_level,count(*) from sh.customers where cust_credit_limit is null group by cust_income_level

-- 15.Display countries where the sum of credit limits exceeds 10 million.

--select country_id,sum(cust_credit_limit) from sh.customers group by country_id having sum(cust_credit_limit) > 10000000

-- 16.Find the state that contributes the highest total credit limit to its country.

--select country_id,cust_state_province,total_credit_limit from
--(
    --select country_id,cust_state_province,sum(cust_credit_limit) total_credit_limit,rank() over(partition by country_id order by total_credit_limit desc) rnk 
    --from sh.customers 
    --group by country_id,cust_state_province
    --)
    --where rnk=1

-- 17.Show total credit limit per year of birth, sorted by total descending.

--select cust_year_of_birth,sum(cust_credit_limit) from sh.customers group by cust_year_of_birth order by sum(cust_credit_limit) desc

-- 18.Identify customers who hold the maximum credit limit in their respective country.

--select country_id,max(cust_credit_limit) from sh.customers group by country_id

-- 19.Show the difference between maximum and average credit limit per country.

--select country_id,max(cust_credit_limit),avg(cust_credit_limit),
--max(cust_credit_limit)-avg(cust_credit_limit) diff_max_average from sh.customers group by country_id order by diff_max_average desc

--  20.Display the overall rank of each state based on its total credit limit (using GROUP BY + analytic rank).

--select cust_state_province,total_credit_limit,rank() over(order by total_credit_limit desc) overall_rank 
--from(
--select cust_state_province,sum(cust_credit_limit) total_credit_limit from sh.customers 
--group by cust_state_province
--) 
--order by overall_rank

 B. Analytical / Window Functions

-- 1.Assign row numbers to customers ordered by credit limit descending.

--select cust_credit_limit, row_number() over(order by cust_credit_limit desc) row_number from sh.customers

-- 2.Rank customers within each state by credit limit.

--select cust_state_province,cust_credit_limit, rank() over (partition by cust_state_province order by cust_credit_limit desc) rank from sh.customers

-- 3.Use DENSE_RANK() to find the top 5 credit holders per country.

--select * from (select cust_credit_limit,country_id,dense_rank() over(partition by cust_credit_limit order by country_id desc) top_credit_limit from sh.customers) where top_credit_limit <=5

-- 4.Divide customers into 4 quartiles based on their credit limit using NTILE(4).

--select cust_id,cust_credit_limit,ntile(4) over(order by cust_credit_limit desc) credit_quartile from sh.customers

-- 5.Calculate a running total of credit limits ordered by customer_id.

--select cust_id,cust_credit_limit,sum(cust_credit_limit) over (order by cust_id desc) running_total from sh.customers order by cust_id

-- 6.Show cumulative average credit limit by country.

--select cust_id,country_id,cust_credit_limit, avg(cust_credit_limit) over(partition by country_id order by cust_id rows between unbounded preceding and current row) cumulative_average from sh.customers order by cust_id,country_id

-- 7.Compare each customer’s credit limit to the previous one using LAG().

--select cust_id,cust_credit_limit,lag(cust_credit_limit) over (order by cust_id) previous_credit_limit,cust_credit_limit-lag(cust_credit_limit) over (order by cust_id) as differ_from_previous from sh.customers order by cust_id

-- 8.Show next customer’s credit limit using LEAD().

--select cust_id,cust_credit_limit,lead(cust_credit_limit) over (order by cust_id) next_credit_limit from sh.customers

-- 9.Display the difference between each customer’s credit limit and the previous one.

--select cust_id,cust_credit_limit,cust_credit_limit - lag(cust_credit_limit) over ( order by cust_id) previous_one from sh.customers 

-- 10.For each country, display the first and last credit limit using FIRST_VALUE() and LAST_VALUE().

--select cust_id,country_id,cust_credit_limit,first_value(cust_credit_limit) over (partition by country_id  order by cust_id rows between unbounded preceding and unbounded following) first_credit_limit,last_value(cust_credit_limit) over(partition by country_id order by cust_id ) last_credit_limit from sh.customers

-- 11.Compute percentage rank (PERCENT_RANK()) of customers based on credit limit.

--select cust_id,cust_first_name,cust_last_name,cust_credit_limit, percent_rank() over (order by cust_credit_limit) percentage_rank from sh.customers

-- 12.Compute percentage rank (PERCENT_RANK()) of customers based on credit limit.

--select cust_id,cust_first_name,cust_last_name,cust_credit_limit,cume_dist() over (order by cust_credit_limit) percentile_position from sh.customers

-- 13.Display the difference between the maximum and current credit limit for each customer.
--
--select cust_id,cust_credit_limit,max(cust_credit_limit) over() maximum_credit_limit,max(cust_credit_limit) over()- cust_credit_limit difference from sh.customers

-- 14.Rank income levels by their average credit limit.

--select cust_income_level,avg(cust_credit_limit) average,rank() over(order by avg(cust_credit_limit) desc)  rank from sh.customers group by cust_income_level

-- 15.Calculate the average credit limit over the last 10 customers (sliding window).

--select cust_id,cust_first_name,cust_last_name,avg(cust_credit_limit) over(order by cust_id rows between 9 preceding and current row)  from sh.customers order by cust_id

-- 16.For each state, calculate the cumulative total of credit limits ordered by city.

--select cust_state_province,cust_city,sum(cust_credit_limit) sum_credit,sum(sum(cust_credit_limit)) over (partition by cust_state_province order by cust_city) cumulative_sum from sh.customers group by cust_state_province,cust_city order by cust_state_province,cust_city 

-- 17.Find customers whose credit limit equals the median credit limit (use PERCENTILE_CONT(0.5)).

--select * from sh.customers where cust_credit_limit = (select percentile_cont(0.5) within group (order by cust_credit_limit) from sh.customers )

-- 18.Display the highest 3 credit holders per state using ROW_NUMBER() and PARTITION BY.

--select * from (select cust_state_province,cust_id,cust_credit_limit,row_number() over(partition by cust_state_province order by cust_credit_limit desc) rnk from sh.customers) where rnk<=3 order by cust_state_province,rnk

-- 19.Identify customers whose credit limit increased compared to previous row (using LAG).

--select cust_id,cust_first_name,cust_last_name,cust_credit_limit,lag(cust_credit_limit) over (order by cust_id) previous_credit_limit,case when cust_credit_limit > lag(cust_credit_limit) over (order by cust_id) then 'incresed' else 'not incresed' end as credit_trend from sh.customers

-- 20.Calculate moving average of credit limits with a window of 3.

--select cust_id,cust_first_name,cust_last_name,cust_credit_limit,avg(cust_credit_limit) over (order by cust_id rows between 2 preceding and current row) moving_average from sh.customers order by cust_id

-- 21.Show cumulative percentage of total credit limit per country.

--select country_id,cust_credit_limit,sum(cust_credit_limit) over (partition by country_id order by cust_credit_limit) cumulative_credit,
round(100*sum(cust_credit_limit) over (partition by country_id order by cust_credit_limit)/sum(cust_credit_limit) over(partition by country_id),2) cumulative_percentage from sh.customers

---- 22.Rank customers by age (derived from CUST_YEAR_OF_BIRTH).

--select cust_id,cust_year_of_birth,extract(year from sysdate) - cust_year_of_birth age,
rank() over(order by(extract (year from sysdate) - cust_year_of_birth)desc) age_rank from sh.customers

-- 23.Calculate difference in age between current and previous customer in the same state.

--select cust_id,cust_year_of_birth,cust_state_province,
(extract(year from sysdate)- cust_year_of_birth) age,
lag(extract(year from sysdate)-cust_year_of_birth)over(partition by cust_state_province order by cust_id) previous_age,
(extract(year from sysdate)- cust_year_of_birth) - lag(extract(year from sysdate)-cust_year_of_birth)over(partition by cust_state_province order by cust_id) age_difference 
from sh.customers where cust_year_of_birth is not null

-- 24.Use RANK() and DENSE_RANK() to show how ties are treated differently.

--select cust_id,cust_credit_limit,rank() over(order by cust_credit_limit desc) rank_credit,dense_rank() over(order by cust_credit_limit desc) dense_rank_credit from sh.customers

-- 25.Compare each state’s average credit limit with country average using window partition.

--select country_id,cust_credit_limit,cust_state_province,
--round(avg(cust_credit_limit) over(partition by country_id,cust_state_province),2) state_average_credit,
--round(avg(cust_credit_limit)over(partition by country_id),2) country_average_credit,
--round(
    --avg(cust_credit_limit) over(partition by country_id,cust_state_province) -
--avg(cust_credit_limit)over(partition by country_id),2) differ_from_country_average
--from sh.customers

-- 26.Show total credit per state and also its rank within each country.

--select country_id,cust_state_province,sum(cust_credit_limit),
--rank() over(partition by country_id order by sum(cust_credit_limit) desc) rank_in_country
--from sh.customers group by country_id,cust_state_province

-- 27.Find customers whose credit limit is above the 90th percentile of their income level.

--select cust_id,cust_income_level,cust_credit_limit from sh.customers
where cust_credit_limit > percentile_cont(0.9) over (order by cust_credit_limit) within group (partition by cust_income_level)
order by cust_income_level, cust_credit_limit desc

-- 28.Display top 3 and bottom 3 customers per country by credit limit.

--select 
  --  country_id,
    --cust_id,
    --cust_first_name,
    --cust_last_name,
    --cust_credit_limit,
    --rank_desc,
    --rank_asc
--from (
  --  select
    --    country_id,
      --  cust_id,
        --cust_first_name,
        --cust_last_name,
        --cust_credit_limit,
        --rank() over (partition by country_id order by cust_credit_limit desc)  rank_desc,
        --rank() over (partition by country_id order by cust_credit_limit asc)   rank_asc from sh.customers
--)
--where
  --  rank_desc <= 3 
    --or rank_asc <= 3  
--order by
  --  country_id,
    --cust_credit_limit desc


-- 29.Calculate rolling sum of 5 customers’ credit limit within each country.

--select cust_id,country_id,cust_credit_limit,
sum(cust_credit_limit) over(partition by country_id order by cust_id rows between 4 preceding and current row) rolling_sum_5
from sh.customers

-- 30.For each marital status, display the most and least wealthy customers using analytical functions.

--select distinct
  --  cust_marital_status,
    --first_value(cust_first_name) over (partition by cust_marital_status order by cust_credit_limit desc)  most_wealthy_customer,
    --first_value(cust_credit_limit) over (partition by cust_marital_status order by cust_credit_limit desc)  highest_credit_limit,
    --first_value(cust_first_name) over (partition by cust_marital_status order by cust_credit_limit asc)  least_wealthy_customer,
    --first_value(cust_credit_limit) over (partition by cust_marital_status order by cust_credit_limit asc)  lowest_credit_limit
--from sh.customers
--where cust_credit_limit is not null
--order by cust_marital_status


-- C. Conditional, CASE, and DECODE
-- 1.Categorize customers into income tiers: Platinum, Gold, Silver, Bronze.

--select cust_id,cust_credit_limit,
--case
    --when cust_credit_limit >= 10000 then 'platinum'
    --when cust_credit_limit >= 5000 then 'gold'
    --when cust_credit_limit >= 2000 then 'silver'
    --else 'bronze'
    --end as income_tier
--from sh.customers

-- 2.Display “High”, “Medium”, or “Low” income categories based on credit limit.

--select cust_id,cust_credit_limit,
--case
    --when cust_credit_limit >= 10000 then 'high'
    --when cust_credit_limit >= 5000 then 'medium'
    --else 'low'
    --end as income_category
    --from sh.customers

-- 3.Replace NULL income levels with “Unknown” using NVL.

--select cust_id,
--nvl(cust_income_level,'unknown') income_level
--from sh.customers

-- 4.Show customer details and mark whether they have above-average credit limit or not.

--select cust_id,cust_credit_limit,
--case
  --  when cust_credit_limit > (select avg(cust_credit_limit) from sh.customers)
    --then 'above_average'
    --else 'below'
    --end as credit_limit_category
--from sh.customers

-- 5.Use DECODE to convert marital status codes (S/M/D) into full text.

--select cust_id,cust_marital_status,
--decode(lower(cust_marital_status),'single','S','married','M','divorced','D','Unknown') marital_status
--from sh.customers

-- 6.Use CASE to show age group (≤30, 31–50, >50) from CUST_YEAR_OF_BIRTH.

--select cust_id,cust_year_of_birth,
--extract(year from sysdate) - cust_year_of_birth age,
--case
    --when extract(year from sysdate) - cust_year_of_birth <=30 then '≤30'
    --when extract(year from sysdate) - cust_year_of_birth between 31 and 50 then '31-50'
    --when extract (year from sysdate) - cust_year_of_birth >50 then '>50'
    --else 'unknown'
    --end as age_grup
    --from sh.customers

-- 7.Label customers as “Old Credit Holder” or “New Credit Holder” based on year of birth < 1980.

--select cust_id,cust_year_of_birth,
--case
    --when cust_year_of_birth < 1980 then 'old credit Holder'
    --else 'New credit Holder'
    --end as credit_holder_status
--from sh.customers

-- 8.Create a loyalty tag — “Premium” if credit limit > 50,000 and income_level = ‘E’.

--select cust_id,cust_credit_limit,cust_income_level,
--case
    --when cust_credit_limit > 50000 and cust_income_level='E'
    --then 'Premium'
    --else 'Regular'
    --end as loyalty_tag
--from sh.customers

-- 9.Assign grades (A–F) based on credit limit range using CASE.

--select cust_id,cust_credit_limit,
--case
    --when cust_credit_limit >=100000 then 'A'
    --when cust_credit_limit >=75000 then 'B'
    --when cust_credit_limit >=50000 then 'C'
    --when cust_credit_limit >=25000 then 'D'
    --when cust_credit_limit >=0 then 'E'
    --else 'F'
    --end as credit_grade
--from sh.customers

-- 10.Show country, state, and number of premium customers using conditional aggregation.

--select country_id,cust_state_province,
--count(case when cust_credit_limit > 50000 and cust_income_level ='E' then 1 end) premium_customers
--from sh.customers
--group by country_id,cust_state_province



-- D. Date & Conversion Functions

-- 1.Convert CUST_YEAR_OF_BIRTH to age as of today.

--select cust_year_of_birth,
--extract(year from sysdate) - cust_year_of_birth current_age
--from sh.customers

-- 2.Display all customers born between 1980 and 1990.

--select cust_id,cust_year_of_birth from sh.customers
--where cust_year_of_birth between 1980 and 1990
--rder by cust_year_of_birth

-- 3.Format date of birth into “Month YYYY” using TO_CHAR.

--select cust_id,cust_year_of_birth,
--to_char(to_date(cust_year_of_birth,'YYYY'),'Month YYYY') formated_date_of_birth
--from sh.customers

-- 4.Convert income level text (like 'A: Below 30,000') to numeric lower limit.



-- 5.Display customer birth decades (e.g., 1960s, 1970s).

--select cust_id,cust_year_of_birth,
--to_char(floor(cust_year_of_birth/10) * 10) birth_decade
--from sh.customers
--order by cust_year_of_birth

-- 6.Show customers grouped by age bracket (10-year intervals).

--select
    --floor((extract(year from sysdate) - cust_year_of_birth) / 10) * 10 as age_lower,
    --floor((extract(year from sysdate)) - cust_year_of_birth) / 10) * 10 + 9 as age_upper,
    --count(*) customer_count from sh.customers
--where cust_year_of_birth is not null
--group by floor(extract(year from sysdate) - cust_year_of_birth) / 10)
--order by age_lower

-- 7.Convert country_id to uppercase and state name to lowercase.

--select country_id,cust_state_province,upper(country_id),
--lower(cust_state_province) from sh.customers

-- 8.Show customers where credit limit > average of their birth decade.

--select * from
--(select cust_id,cust_year_of_birth,cust_credit_limit,
--floor(cust_year_of_birth / 10)*10 as birth_decade,
--avg(cust_credit_limit) over(partition by floor(cust_year_of_birth/10)) as average_decade_limit
--from sh.customers) 
--where cust_credit_limit > average_decade_limit
--order by cust_year_of_birth

-- 9.Convert all numeric credit limits to currency format $999,999.00.

--select cust_id,cust_credit_limit,
--to_char(cust_credit_limit,'$999,999.00') as formatted_credit_limit
--from sh.customers

-- 10.Find customers whose credit limit was NULL and replace with average (using NVL).

--select cust_id,cust_credit_limit,
--nvl(cust_credit_limit, avg(cust_credit_limit) over (partition by cust_id)) adjusted_credit_limit
--from sh.customers
