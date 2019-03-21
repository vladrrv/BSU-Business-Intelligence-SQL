REM   Script: Lab4
REM   Lab 4

-- Task 1
-- Создайте блоки данных фиксированного размера.
SELECT CEIL(ROW_NUMBER()OVER (ORDER BY JobNo)/3.0) Grp, JobNo, JobName  
FROM Job;

-- Task 2
-- Создайте заданное количества блоков.
SELECT NTILE(3)OVER (ORDER BY JobNo) Grp, JobNo, JobName  
FROM Job;

-- Task 3
-- Создайте горизонтальную гистограмму.
SELECT JobNo, LPAD ('*', COUNT(*), '*') cnt   
FROM career  
GROUP BY JobNo  
ORDER BY cnt;

-- Task 4
-- Создайте вертикальную гистограмму.
SELECT MAX(Year_2007) Y2007,   
       MAX(Year_2008) Y2008,   
       MAX(Year_2009) Y2009,   
       MAX(Year_2010) Y2010   
FROM (   
    SELECT ROW_NUMBER()OVER(PARTITION BY Year ORDER BY EmpNo) RN,   
        CASE WHEN Year=2007 THEN '*' ELSE NULL END Year_2007,   
        CASE WHEN Year=2008 THEN '*' ELSE NULL END Year_2008,   
        CASE WHEN Year=2009 THEN '*' ELSE NULL END Year_2009,   
        CASE WHEN Year=2010 THEN '*' ELSE NULL END Year_2010   
    FROM Salary   
)   
GROUP BY RN  
ORDER BY 1 DESC, 2 DESC, 3 DESC, 4 DESC;

