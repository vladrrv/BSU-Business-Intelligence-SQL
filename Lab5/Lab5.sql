REM   Script: Lab5.1
REM   Аналитические функции и методы ORACLE SQL. Функции ранжирования


-- Task 1
-- Используя функцию RANK выполнить ранжирование значений средних зарплат по годам. 
SELECT Year, Year_Avg_Salary, RANK()OVER(ORDER BY Year_Avg_Salary) Rnk  
FROM (  
    SELECT Year, ROUND(AVG(SalValue),2) Year_Avg_Salary  
    FROM Salary  
    GROUP BY Year  
);

-- Task 2
-- Используя функцию DENSE_RANK выполнить ранжирование значений суммарных зарплат по годам и месяцам. 
SELECT Year, Month, Year_Sum_Salary, DENSE_RANK()OVER(ORDER BY Year_Sum_Salary) Rnk  
FROM (  
    SELECT Year, Month, ROUND(SUM(SalValue),2) Year_Sum_Salary  
    FROM Salary  
    GROUP BY Year, Month  
);

-- Task 3.1
-- Используя функции RANK выполнить ранжирование значений зарплат по годам и месяцам для каждого имени сотрудника (PARTITION BY).
SELECT EmpNo, Year, Month, SalValue, RANK()OVER(PARTITION BY EmpNo ORDER BY SalValue) Rnk  
FROM Salary;

-- Task 3.2
-- Используя функции DENSE_RANK выполнить ранжирование значений зарплат по годам и месяцам для каждого имени сотрудника (PARTITION BY).
SELECT EmpNo, Year, Month, SalValue, DENSE_RANK()OVER(PARTITION BY EmpNo ORDER BY SalValue) Rnk  
FROM Salary;

-- Task 4
-- Используя функцию RANK выполнить ранжирование значений средних зарплат по годам и месяцам, по годам, по месяцам (CUBE, GROUPING_ID).
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

-- Task 5
-- Используя функцию CUME_DIST определить позицию зарплаты сотрудника относительно должностей.
SELECT JobName, EmpName, SalValue, ROUND(CUME_DIST() OVER(PARTITION BY JobNo ORDER BY SalValue), 3) Cume_Dist  
FROM Job JOIN Career USING(JobNo) JOIN Emp USING(EmpNo) JOIN Salary USING(EmpNo);

-- Task 6
-- Используя функцию PERCENT_RANK определить позицию зарплаты сотрудника относительно должностей.
SELECT JobName, EmpName, SalValue, ROUND(PERCENT_RANK() OVER(PARTITION BY JobNo ORDER BY SalValue), 3) Pct_Rank  
FROM Job JOIN Career USING(JobNo) JOIN Emp USING(EmpNo) JOIN Salary USING(EmpNo);

