REM   Script: Lab2
REM   Lab 2

-- Task 1
SELECT MAX(CASE WHEN JobName='EXECUTIVE DIRECTOR' THEN EmpCount ELSE 0 END) AS "EXECUTIVE_DIRECTOR",  
       MAX(CASE WHEN JobName='SALESMAN' THEN EmpCount ELSE 0 END) AS "SALESMAN",  
       MAX(CASE WHEN JobName='CLERK' THEN EmpCount ELSE 0 END) AS "CLERK",  
       MAX(CASE WHEN JobName='MANAGER' THEN EmpCount ELSE 0 END) AS "MANAGER",  
       MAX(CASE WHEN JobName='DRIVER' THEN EmpCount ELSE 0 END) AS "DRIVER",  
       MAX(CASE WHEN JobName='FINANCIAL DIRECTOR' THEN EmpCount ELSE 0 END) AS "FINANCIAL_DIRECTOR",  
       MAX(CASE WHEN JobName='PRESIDENT' THEN EmpCount ELSE 0 END) AS "PRESIDENT"  
FROM (  
    SELECT JobName, COUNT(EmpNo) "EMPCOUNT"  
    FROM (Job JOIN Career USING (JobNo))  
    GROUP BY JobName  
) ;

-- Task 2
SELECT MAX(CASE WHEN DeptName='ACCOUNTING' THEN EmpName END) AS "ACCOUNTING",  
       MAX(CASE WHEN DeptName='RESEARCH' THEN EmpName END) AS "RESEARCH",  
       MAX(CASE WHEN DeptName='SALES' THEN EmpName END) AS "SALES",  
       MAX(CASE WHEN DeptName='OPERATIONS' THEN EmpName END) AS "OPERATIONS"  
  
FROM (  
    SELECT DeptName, EmpName, ROW_NUMBER()OVER(PARTITION BY DeptName ORDER BY EmpName) RN  
    FROM Dept JOIN (Emp JOIN Career USING (EmpNo)) USING (DeptNo)  
)  
GROUP BY RN ;

-- Task 3
SELECT JobName,   
    CASE JobName   
        WHEN 'EXECUTIVE DIRECTOR' THEN Emp_Cnts.EXECUTIVE_DIRECTOR   
        WHEN 'SALESMAN' THEN Emp_Cnts.SALESMAN   
        WHEN 'CLERK' THEN Emp_Cnts.CLERK   
        WHEN 'MANAGER' THEN Emp_Cnts.MANAGER   
        WHEN 'DRIVER' THEN Emp_Cnts.DRIVER   
        WHEN 'FINANCIAL DIRECTOR' THEN Emp_Cnts.FINANCIAL_DIRECTOR   
        WHEN 'PRESIDENT' THEN Emp_Cnts.PRESIDENT   
    END AS EMPCOUNT   
FROM (   
    SELECT MAX(CASE WHEN JobName='EXECUTIVE DIRECTOR' THEN EmpCount ELSE 0 END) AS "EXECUTIVE_DIRECTOR",   
           MAX(CASE WHEN JobName='SALESMAN' THEN EmpCount ELSE 0 END) AS "SALESMAN",   
           MAX(CASE WHEN JobName='CLERK' THEN EmpCount ELSE 0 END) AS "CLERK",   
           MAX(CASE WHEN JobName='MANAGER' THEN EmpCount ELSE 0 END) AS "MANAGER",   
           MAX(CASE WHEN JobName='DRIVER' THEN EmpCount ELSE 0 END) AS "DRIVER",   
           MAX(CASE WHEN JobName='FINANCIAL DIRECTOR' THEN EmpCount ELSE 0 END) AS "FINANCIAL_DIRECTOR",   
           MAX(CASE WHEN JobName='PRESIDENT' THEN EmpCount ELSE 0 END) AS "PRESIDENT"   
              
    FROM (   
        SELECT JobName, COUNT(EmpNo) "EMPCOUNT"   
        FROM (Job JOIN Career USING (JobNo))   
        GROUP BY JobName   
    )    
) Emp_Cnts, Job  ;

-- Task 4 (Create View)
CREATE OR REPLACE VIEW EmpsInfo AS (  
    SELECT EmpNo, EmpName, JobName, DeptNo, ROUND(AVG(SalValue)) AS AvgSalary   
    FROM ( Emp JOIN Salary USING(EmpNo) JOIN Career USING(EmpNo) JOIN Job USING(JobNo) JOIN Dept USING(DeptNo) )  
    WHERE EndDate IS NULL   
    GROUP BY EmpNo, EmpName, JobName, DeptNo   
);

-- Task 4
SELECT  
    CASE RN 
        WHEN 1 THEN EmpName 
        WHEN 2 THEN JobName 
        WHEN 3 THEN CAST(AvgSalary AS CHAR(4)) 
    END Emps 
FROM ( 
    SELECT e.EmpName, e.JobName, e.AvgSalary, ROW_NUMBER()OVER(PARTITION BY e.EmpNo ORDER BY e.EmpNo) RN 
    FROM EmpsInfo e, EmpsInfo 
    WHERE (e.DeptNo = 40) 
);

-- Task 5
SELECT TO_NUMBER( 
    DECODE(LAG(DeptNo) OVER(ORDER BY DeptNo), DeptNo, NULL, DeptNo) 
) DeptNo, EmpName 
FROM Emp JOIN Career USING(EmpNo) JOIN Dept USING(DeptNo);

