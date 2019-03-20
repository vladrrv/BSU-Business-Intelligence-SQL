--1
SELECT Year, Year_Avg_Salary, RANK()OVER(ORDER BY Year_Avg_Salary) Rnk
FROM (
    SELECT Year, ROUND(AVG(SalValue),2) Year_Avg_Salary
    FROM Salary
    GROUP BY Year
);
--2
SELECT Year, Month, Year_Sum_Salary, DENSE_RANK()OVER(ORDER BY Year_Sum_Salary) Rnk
FROM (
    SELECT Year, Month, ROUND(SUM(SalValue),2) Year_Sum_Salary
    FROM Salary
    GROUP BY Year, Month
);
--3.1
SELECT Empno, Year, Month, SalValue, RANK()OVER(PARTITION BY Empno ORDER BY SalValue) Rnk
FROM Salary;
--3.2
SELECT Empno, Year, Month, SalValue, DENSE_RANK()OVER(PARTITION BY Empno ORDER BY SalValue) Rnk
FROM Salary;

--4
SELECT Year, Month, Category, Avg_Salary, RANK()OVER(PARTITION BY Group_YearMonth ORDER BY Avg_Salary) Rnk
FROM (
    SELECT Year, Month, GROUPING(Year) || GROUPING(Month) Group_YearMonth,  
         CASE GROUPING(Year) || GROUPING(Month)  
              WHEN '00' THEN 'AVERAGE BY YEAR and MONTH'  
              WHEN '10' THEN 'AVERAGE BY MONTH'  
              WHEN '01' THEN 'AVERAGE BY YEAR'  
              WHEN '11' THEN 'GRAND AVERAGE for TABLE'  
         END Category,  
         ROUND(AVG(SalValue),2) Avg_Salary  
    FROM Salary   
    GROUP BY CUBE(Year, Month)   
    ORDER BY GROUPING(Year), GROUPING(Month)
);