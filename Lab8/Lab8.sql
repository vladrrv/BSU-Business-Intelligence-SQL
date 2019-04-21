REM   Script: Lab8
REM   Final

SELECT Table_Name  
FROM User_Tables 
WHERE Table_Name LIKE 'JO%';

SELECT SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee Names" 
FROM Employees;

SELECT First_Name || ' ' || Last_Name AS "Employee Name", Email 
FROM Employees 
WHERE Email LIKE '%IN%';

SELECT  
    MAX(CASE WHEN Rn = 1 THEN Last_Name END) AS "First Last Name", 
    MAX(CASE WHEN Rn = Cnt THEN Last_Name END) AS "Last Last Name" 
FROM ( 
    SELECT Last_Name, ROW_NUMBER() OVER(ORDER BY Last_Name) AS Rn, COUNT(*) OVER() as Cnt 
    FROM Employees 
);

SELECT '$' || TO_CHAR(Salary/(365/12)*7, '9999.99') "Weekly Salary" 
FROM Employees 
WHERE Salary/(365/12)*7 BETWEEN 700 AND 3000;

SELECT SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee Name", Job_Title AS Job 
FROM Employees JOIN Jobs USING(Job_Id) 
ORDER BY Job_Title;

SELECT  
    SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee Name", Job_Title AS Job, 
    Min_Salary || ' - ' || Max_Salary AS "Salary Range", Salary AS "Employee's Salary" 
FROM Employees JOIN Jobs USING(Job_Id) 
ORDER BY Job_Title;

SELECT SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee Name", Department_Name AS "Department Name" 
FROM Employees JOIN Departments USING(Department_Id, Manager_Id);

SELECT SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee Name", Department_Name AS "Department Name" 
FROM Employees JOIN Departments USING(Department_Id);

SELECT  
    DECODE (Manager_Id, NULL, 'Nobody', 'Somebody') AS "Works for", 
    Last_Name AS "Last Name" 
FROM Employees;

SELECT  
    SUBSTR(First_Name, 0, 1) || ' ' || Last_Name "Employee Name", Salary "Salary", 
    DECODE (Commission_Pct, NULL, 'No', 'Yes') "Commission" 
FROM Employees;

SELECT  
    Last_Name, Department_Name, City, State_Province 
FROM Departments LEFT OUTER JOIN Employees USING(Department_Id) JOIN Locations USING(Location_Id) 
ORDER BY Last_Name;

SELECT  
    First_Name "First Name", Last_Name "Last Name",  
    CASE  
        WHEN Commission_Pct IS NOT NULL THEN Commission_Pct  
        WHEN Manager_Id IS NOT NULL THEN Manager_Id 
        ELSE -1 
    END AS "Which function???" 
FROM Employees;

SELECT Last_Name, Salary, Grade_Level 
FROM Employees, Job_Grades 
WHERE Salary BETWEEN Lowest_Sal AND Highest_Sal AND Department_Id > 50;

SELECT Last_Name, Department_Name 
FROM Employees FULL OUTER JOIN Departments USING(Department_Id);

SELECT LEVEL Position, Last_Name, PRIOR Last_Name AS Manager_Name 
FROM Employees 
START WITH Manager_Id is NULL   
CONNECT BY PRIOR Employee_Id = Manager_Id;

SELECT MIN(Hire_Date) "Lowest", MAX(Hire_Date) "Highest", COUNT(*) "No of Employees" 
FROM Employees;

SELECT * 
FROM ( 
    SELECT Department_Name, SUM(Salary) Salaries 
    FROM Employees JOIN Departments USING(Department_Id) 
    GROUP BY Department_Name 
) 
WHERE Salaries BETWEEN 15000 AND 31000 
ORDER BY Salaries;

SELECT Department_Name, Departments.Manager_Id, Last_Name Manager_Name, Avg_Dept_Salary 
FROM ( 
    SELECT Employees.*,  ROUND(AVG(Salary) OVER(PARTITION BY Employees.Department_Id)) Avg_Dept_Salary 
    FROM Employees 
) Emp, Departments  
WHERE Emp.Employee_Id = Departments.Manager_Id 
ORDER BY Avg_Dept_Salary;

SELECT ROUND(MAX(Avg_Dept_Salary)) "Highest Avg Sal for Depts" 
FROM ( 
    SELECT AVG(Salary) Avg_Dept_Salary 
    FROM Employees 
    GROUP BY Department_Id 
);

SELECT Department_Name "Department Name", Monthly_Cost "Monthly Cost" 
FROM ( 
    SELECT Department_Id, SUM(Salary) Monthly_Cost 
    FROM Employees 
    GROUP BY Department_Id 
) JOIN Departments USING (Department_Id);

SELECT Department_Name, Job_Id, Monthly_Cost 
FROM (   
    SELECT  
        Department_Name, Job_Id, SUM(Salary) Monthly_Cost, 
        GROUPING(Department_Name) || GROUPING(Job_Id) Cat 
    FROM Employees JOIN Departments USING (Department_Id) 
    GROUP BY CUBE(Department_Name, Job_Id)      
    ORDER BY Department_Name, Job_Id 
)  
WHERE Cat != '10';

SELECT  
    Department_Name "Department Name", Job_Id "Job Title", SUM(Salary) "Monthly Cost" 
FROM Employees JOIN Departments USING (Department_Id) 
GROUP BY CUBE(Department_Name, Job_Id)      
ORDER BY Department_Name, Job_Id;

SELECT  
    Department_Name "Department Name", Job_Id "Job Title", SUM(Salary) "Monthly Cost", 
    CASE GROUPING(Department_Name) 
        WHEN 0 THEN 'Yes' 
        WHEN 1 THEN 'No' 
    END "Department ID Used", 
    CASE GROUPING(Job_Id)  
        WHEN 0 THEN 'Yes' 
        WHEN 1 THEN 'No' 
    END "Job ID Used" 
FROM Employees JOIN Departments USING (Department_Id) 
GROUP BY CUBE(Department_Name, Job_Id)      
ORDER BY Department_Name, Job_Id;

SELECT Department_Name, Job_Id, City, SUM(Salary) 
FROM Employees JOIN Departments USING (Department_Id) JOIN Locations USING (Location_Id) 
GROUP BY GROUPING SETS((Department_Name, Job_Id), (City))      
ORDER BY Department_Name, City;

SELECT  
    SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee Names", 
    Department_Id "Department Id",  
    NULL "Department Name", 
    NULL "City" 
FROM Employees 
UNION 
SELECT  
    NULL "Employee Names", 
    Department_Id "Department Id",  
    Department_Name "Department Name", 
    NULL "City" 
FROM Departments 
UNION 
SELECT 
    NULL "Employee Names", 
    NULL "Department Id",  
    NULL "Department Name", 
    City "City" 
FROM Locations;

SELECT 
    SUBSTR(First_Name, 0, 1) || ' ' || Last_Name AS "Employee", 
    Salary "Salary", 
    Department_Name "Department Name" 
FROM ( 
    SELECT Employees.*, AVG(Salary)OVER(PARTITION BY Department_Id) S 
    FROM Employees 
) JOIN Departments USING(Department_Id) 
WHERE Salary > S;

