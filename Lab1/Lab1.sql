REM   Script: Lab1
REM   Lab 1

-- Task 1
SELECT * FROM Dept WHERE (DeptName = 'SALES');

-- Task 2
SELECT * FROM Dept WHERE (DeptAddr IN ('CHICAGO', 'NEW YORK'));

-- Task 3
SELECT MIN(SalValue) FROM Salary WHERE Year=2009;

-- Task 4
SELECT COUNT(EmpNo) FROM Emp;

-- Task 5
SELECT DECODE (JobName, 'CLERK','WORKER', 
                        'DRIVER','WORKER', 
                        JobName) JobName, JobNo, MinSalary FROM Job;

-- Task 6
SELECT Year,MAX(SalValue) FROM Salary 
GROUP BY Year;

-- Task 7
SELECT Year,AVG(SalValue) FROM Salary 
GROUP BY Year 
HAVING COUNT(Year) >= 4;

-- Task 8
SELECT Emp.*, Career.*, Salary.*  
FROM Emp, Career, Salary;

-- Task 9
SELECT Salary.*, Emp.EmpName  
FROM Salary  
JOIN Emp 
  ON Emp.EmpNo = Salary.EmpNo 
ORDER BY EmpName;

-- Task 10
SELECT Career.*, Emp.EmpName, Job.JobName, Dept.DeptName  
FROM Career 
JOIN Emp 
  ON Career.EmpNo = Emp.EmpNo 
JOIN Job 
  ON Career.JobNo = Job.JobNo 
JOIN Dept 
  ON Career.DeptNo = Dept.DeptNo;

-- Task 11
SELECT Emp.EmpName 
FROM Salary 
JOIN Emp 
  ON Salary.EmpNo = Emp.EmpNo 
WHERE Salary.SalValue IN (SELECT MIN(SalValue) 
                          FROM Salary 
                          GROUP BY Year);

-- Task 12
SELECT Emp.*, 
CASE 
    WHEN (MONTHS_BETWEEN(CURRENT_DATE, BirthDate)/12 BETWEEN 20 AND 30) THEN 'Group 1' 
    WHEN (MONTHS_BETWEEN(CURRENT_DATE, BirthDate)/12 BETWEEN 31 AND 40) THEN 'Group 2' 
    WHEN (MONTHS_BETWEEN(CURRENT_DATE, BirthDate)/12 BETWEEN 41 AND 50) THEN 'Group 3' 
    WHEN (MONTHS_BETWEEN(CURRENT_DATE, BirthDate)/12 BETWEEN 51 AND 60) OR BirthDate is NULL THEN 'Group 4' 
    ELSE 'Undefined' 
END AS AgeGroup 
FROM Emp;

