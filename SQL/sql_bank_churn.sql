select *
from bank_churn;

describe bank_churn;

SELECT *
FROM bank_churn
where CreditScore is null;

# total customers
select count(*) as Total_Customers
from bank_churn;

#churn rate
select Exited , count(*) as Customers
from bank_churn
group by Exited;

# average age
select avg(Age) as Average_age
from bank_churn;

# customers by country 
select Geography,count(*) as customers
from bank_churn
group by Geography
order by customers desc;

# average balance
select Geography,avg(Balance) as avg_bal
from bank_churn
group by Geography
order by avg_bal desc;

# avg salary by churn
select Exited,avg(EstimatedSalary) as avg_sal
from bank_churn
group by Exited
order by avg_sal desc;

# churn rate by geography
select Geography,count(*) as Customers, sum(Exited) as churned_customers,
round(sum(Exited)*100.0 / count(*),2) as churn_rate
from bank_churn
group by Geography
order by churn_rate desc;

# churn rate by gender
select Gender,count(*) as Customers, sum(Exited) as churned_customers,
round(sum(Exited)*100.0 / count(*),2) as churn_rate
from bank_churn
group by Gender
order by churn_rate desc;

# avg credit score
select Exited ,round(avg(CreditScore),2) as avg_creditscore
from bank_churn
group by Exited;

# avg no of pdts
select Exited,round(avg(NumOfProducts),2) as avg_pdts
from bank_churn
group by Exited;

# active member vs churn rate
SELECT IsActiveMember,
       COUNT(*) AS Customers,
       SUM(Exited) AS Churned,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS Churn_Rate
FROM bank_churn
GROUP BY IsActiveMember;

# churn rate by age_group
select 
     case
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
	 end as age_group,
     count(*) as customers,
     sum(Exited) as churn_customers,
     round(sum(Exited)*100.0/count(*),2) as churn_rate
     from bank_churn
     group by age_group
     order by churn_rate desc;

# churn rate by creditscore
SELECT
CASE
    WHEN CreditScore < 500 THEN 'Poor'
    WHEN CreditScore BETWEEN 500 AND 649 THEN 'Average'
    WHEN CreditScore BETWEEN 650 AND 749 THEN 'Good'
    ELSE 'Excellent'
END AS Credit_Category,

COUNT(*) AS Customers,

SUM(Exited) AS Churned,

ROUND(SUM(Exited)*100.0/COUNT(*),2) AS Churn_Rate

FROM bank_churn

GROUP BY Credit_Category

ORDER BY Churn_Rate DESC;

# churn rate by balance category
SELECT
CASE
    WHEN Balance = 0 THEN 'Zero Balance'
    WHEN Balance < 50000 THEN 'Low Balance'
    WHEN Balance < 100000 THEN 'Medium Balance'
    ELSE 'High Balance'
END AS Balance_Category,

COUNT(*) AS Customers,

SUM(Exited) AS Churned,

ROUND(SUM(Exited)*100.0/COUNT(*),2) AS Churn_Rate

FROM bank_churn

GROUP BY Balance_Category

ORDER BY Churn_Rate DESC;


# churn rate by pdts
SELECT
NumOfProducts,
COUNT(*) AS Customers,
SUM(Exited) AS Churned,
ROUND(SUM(Exited)*100.0/COUNT(*),2) AS Churn_Rate
FROM bank_churn

GROUP BY NumOfProducts

ORDER BY NumOfProducts;

# credit card impact
SELECT

HasCrCard,

COUNT(*) AS Customers,

SUM(Exited) AS Churned,

ROUND(SUM(Exited)*100.0/COUNT(*),2) AS Churn_Rate

FROM bank_churn

GROUP BY HasCrCard;

alter table bank_churn
rename column ï»¿CustomerId to CustomerId;
# top 10 customers by salary
SELECT
CustomerId,
Surname,
EstimatedSalary
FROM bank_churn
ORDER BY EstimatedSalary DESC
LIMIT 10;

# overall customer summary
SELECT
COUNT(*) AS Total_Customers,
ROUND(AVG(Age),2) AS Average_Age,
ROUND(AVG(Balance),2) AS Average_Balance,
ROUND(AVG(CreditScore),2) AS Average_CreditScore,
ROUND(AVG(EstimatedSalary),2) AS Average_Salary
FROM bank_churn;

SELECT *
FROM (
    SELECT
        CustomerId,
        Surname,
        Geography,
        Balance,
        RANK() OVER (
            PARTITION BY Geography
            ORDER BY Balance DESC
        ) AS Balance_Rank
    FROM bank_churn
) ranked_customers
WHERE Balance_Rank <= 5;

WITH churn_summary AS
(
    SELECT
        Geography,
        COUNT(*) AS Customers,
        SUM(Exited) AS Churned
    FROM bank_churn
    GROUP BY Geography
)

SELECT *,
       ROUND(Churned*100.0/Customers,2) AS Churn_Rate
FROM churn_summary;