REM   Script: Lab7
REM   Иерархические запросы

-- Task 1
-- Требуется представить имя каждого сотрудника таблицы EMP, а также имя его руководителя.
SELECT E1.EmpName || ' works for ' || E2.EmpName AS Emp_Manager  
FROM Emp E1, Emp E2  
WHERE E1.Manager_Id = E2.EmpNo;

-- Task 2
-- Требуется представить имя каждого сотрудника таблицы EMP (даже сотрудника,
которому не назначен руководитель) и имя его руководителя.
SELECT EmpName || ' reports to ' || PRIOR EmpName AS "Walk Top Down"   
FROM Emp  
START WITH Manager_Id is NULL  
CONNECT BY PRIOR EmpNo = Manager_Id;

-- Task 3
-- Требуется показать иерархию от CLARK до JOHN KLINTON.
SELECT LTRIM(SYS_CONNECT_BY_PATH(EmpName,'-->'), '-->') Leaf___Branch___Root  
FROM Emp  
WHERE LEVEL = 3  
START WITH EmpName = 'CLARK'  
CONNECT BY PRIOR Manager_Id = EmpNo;

-- Task 4
-- Требуется получить результирующее множество, описывающее иерархию всей таблицы.
SELECT LTRIM(SYS_CONNECT_BY_PATH(EmpName,' --> '),' --> ') Emp_Tree  
FROM Emp  
START WITH Manager_Id is NULL  
CONNECT BY PRIOR EmpNo = Manager_Id  
ORDER BY 1;

-- Task 5
-- Требуется показать уровень иерархии каждого сотрудника.
SELECT LPAD('_', (LEVEL-1)*2, '_') || EmpName Emp_Tree  
FROM Emp  
START WITH Manager_Id is NULL  
CONNECT BY PRIOR EmpNo = Manager_Id;

-- Task 6
-- Требуется найти всех служащих, которые явно или неявно подчиняются ALLEN.
SELECT EmpName  
FROM Emp  
START WITH EmpName = 'ALLEN'  
CONNECT BY PRIOR EmpNo = Manager_Id;

