REM   Script: Lab3
REM   Lab 3

-- Task 1
-- Получить результирующее множество, содержащее количество сотрудников в каждом отделе, а также общее количество сотрудников.
SELECT  
    CASE GROUPING(DeptName)  
        WHEN 0 THEN DeptName  
        ELSE 'Total'  
    END DeptName,  
    COUNT(EmpNo) Emp_Count  
FROM Dept JOIN Career USING(DeptNo)  
GROUP BY ROLLUP(DeptName);

-- Task 2
-- Требуется найти количество сотрудников по отделам, по должностям и для каждого сочетания DEPTNAME/JOBNAME.
SELECT DeptName, JobName,  
     CASE GROUPING(DeptName) || GROUPING(JobName)  
          WHEN '00' THEN 'TOTAL BY DEPT and JOB'  
          WHEN '10' THEN 'TOTAL BY J0B'  
          WHEN '01' THEN 'TOTAL BY DEPT'  
          WHEN '11' THEN 'GRAND TOTAL for TABLE'  
     END category,  
     COUNT(EmpNo) Emp_Count  
FROM Career JOIN Job USING(JobNo) JOIN Dept USING(DeptNo)   
GROUP BY CUBE(DeptName, JobName)   
ORDER BY GROUPING(DeptName), GROUPING(JobName);

-- Task 3
-- Требуется найти среднее значение суммы всех заработных плат по отделам, по должностям и для каждого сочетания DEPTNAME/JOBNAME.
SELECT DeptName, JobName,  
     CASE GROUPING(DeptName) || GROUPING(JobName)  
          WHEN '00' THEN 'AVERAGE BY DEPT and JOB'  
          WHEN '10' THEN 'AVERAGE BY J0B'  
          WHEN '01' THEN 'AVERAGE BY DEPT'  
          WHEN '11' THEN 'GRAND AVERAGE for TABLE'  
     END category,  
     ROUND(AVG(SalValue),2) Avg_Salary  
FROM Salary JOIN Career USING(EmpNo) JOIN Job USING(JobNo) JOIN Dept USING(DeptNo)   
GROUP BY CUBE(DeptName, JobName)   
ORDER BY GROUPING(DeptName), GROUPING(JobName);

-- Task 4
-- Создайте запрос на распознавание строк, сформированных оператором GROUP BY, и строк, являющихся результатом выполнения CUBE.
SELECT DeptName, JobName, ROUND(AVG(SalValue),2) Avg_Salary,  
    GROUPING(DeptName) Dept_Subtotal,   
    GROUPING(JobName) Job_Subtotal  
FROM Salary JOIN Career USING(EmpNo) JOIN Job USING(JobNo) JOIN Dept USING(DeptNo)   
GROUP BY CUBE(DeptName, JobName);

-- Task 5.1
-- Требуется выполнить агрегацию «в разных измерениях» одновременно. Например, необходимо получить результирующее множество, в котором для каждого сотрудника указаны имя, отдел, количество сотрудников в отделе (включая его самого), количество сотрудников, занимающих ту же должность, что и этот сотрудник (включая его самого), и общее число сотрудников в таблице.
SELECT EmpName,   
    DeptName, COUNT(*)OVER(PARTITION BY DeptNo) DeptName_Emp_Cnt,  
    JobName, COUNT(*)OVER(PARTITION BY JobNo) DeptName_Emp_Cnt,  
    COUNT(*)OVER() Total  
FROM Emp JOIN Career USING(EmpNo) JOIN Job USING(JobNo) JOIN Dept USING(DeptNo);

-- Task 5.2
-- Требуется выполнить скользящую агрегацию, например, найти скользящую сумму заработных плат. Вычислять сумму для каждого интервала в 90 день, начиная с даты приема на работу (поле STARTDATE таблицы CAREER) первого сотрудника, чтобы увидеть динамику изменения расходов для каждого 90-дневного периода между датами приема на работу первого и последнего сотрудника.
SELECT StartDate, SalValue, SUM(SalValue) OVER(PARTITION BY (RANGE BETWEEN 90 PRECEDING AND CURRENT ROW) ORDER BY StartDate) Spending_Pattern  
  
FROM Career JOIN Salary USING(EmpNo) ;

-- Task 5.3
-- Требуется вывести множество числовых значений, представив каждое из них как долю от целого в процентном выражении. Например, требуется получить результирующее множество, отражающее распределение заработных плат по должностям, чтобы можно было увидеть, какая из позиций JOB обходится компании дороже всего.
SELECT JobName, COUNT(EmpNo) Num_Emps,  
    CONCAT(TO_CHAR(100*ROUND(RATIO_TO_REPORT(SUM(SalValue)) OVER (), 3)), '%') Pct_Of_All_Salaries  
  
FROM Job JOIN Career USING(JobNo) JOIN Salary USING(EmpNo)  
GROUP BY (JobName);

