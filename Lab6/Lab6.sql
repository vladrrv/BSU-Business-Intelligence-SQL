REM   Script: Lab6
REM   Работа с датами

-- Task 1
-- Требуется используя значения столбца START_DATE получить дату за десять дней до и после приема на работу, пол года до и после приема на работу, год до и после приема на работу сотрудника JOHN KLINTON.
SELECT   
    StartDate - 10, StartDate + 10,   
    ADD_MONTHS(StartDate, -6), ADD_MONTHS(StartDate, 6),  
    ADD_MONTHS(StartDate, -12), ADD_MONTHS(StartDate, 12)  
FROM Career JOIN Emp USING(EmpNo)  
WHERE EmpName = 'JOHN KLINTON';

-- Task 2
-- Требуется найти разность между двумя датами и представить результат в днях. Вычислите разницу в днях между датами приема на работу сотрудников JOHN MARTIN и ALEX BOUSH.
SELECT ABS(SD1-SD2) Day_Diff  
FROM (  
    SELECT   
        MAX(CASE WHEN EmpName = 'JOHN MARTIN' THEN StartDate END) SD1,  
        MAX(CASE WHEN EmpName = 'ALEX BOUSH' THEN StartDate END) SD2  
    FROM Career JOIN Emp USING(EmpNo)  
);

-- Task 3
-- Требуется найти разность между двумя датами в месяцах и в годах.
SELECT   
    ROUND(ABS(MONTHS_BETWEEN(SD1,SD2)), 2) Month_Diff,  
    ROUND(ABS(MONTHS_BETWEEN(SD1,SD2))/12, 2) Year_Diff  
FROM (  
    SELECT   
        MAX(CASE WHEN EmpName = 'JOHN MARTIN' THEN StartDate END) SD1,  
        MAX(CASE WHEN EmpName = 'ALEX BOUSH' THEN StartDate END) SD2  
    FROM Career JOIN Emp USING(EmpNo)  
);

-- Task 4
-- Требуется определить интервал времени в днях между двумя датами. Для каждого сотрудника 20-го отделе найти сколько дней прошло между датой его приема на работу и датой приема на работу следующего сотрудника.
SELECT EmpName, StartDate, (LEAD(StartDate) OVER(ORDER BY StartDate) - StartDate) Next_Diff  
FROM Career JOIN Emp USING(EmpNo)  
WHERE DeptNo = 20;

-- Task 5
-- Требуется подсчитать количество дней в году по столбцу START_DATE.
SELECT ADD_MONTHS(TRUNC(SYSDATE, 'yy'), 12)-TRUNC(SYSDATE, 'yy') Days_In_Year  
FROM DUAL;

-- Task 6
-- Требуется разложить текущую дату на день, месяц, год, секунды, минуты, часы. Результаты вернуть в численном виде.
SELECT   
    TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy'), '9999') Year,  
    TO_NUMBER(TO_CHAR(SYSDATE, 'mm'), '99') Month,  
    TO_NUMBER(TO_CHAR(SYSDATE, 'dd'), '99') Day,   
    TO_NUMBER(TO_CHAR(SYSDATE, 'ss'), '99') Seconds,   
    TO_NUMBER(TO_CHAR(SYSDATE, 'mi'), '99') Minutes,   
    TO_NUMBER(TO_CHAR(SYSDATE, 'hh24'), '99') Hours  
FROM DUAL;

-- Task 7
-- Требуется получить первый и последний дни текущего месяца.
SELECT TRUNC(SYSDATE, 'mm') First_Day, LAST_DAY(SYSDATE) Last_Day  
FROM DUAL;

-- Task 8
-- Требуется возвратить даты начала и конца каждого из четырех кварталов данного года.
SELECT ROW_NUMBER()OVER(ORDER BY First_Day) Quarter, First_Day, ADD_MONTHS(First_Day,3)-1 Last_Day  
FROM (  
    SELECT ADD_MONTHS(TRUNC(SYSDATE, 'yy'),(level-1)*3) First_Day  
    FROM DUAL  
    CONNECT BY level <= 4  
);

-- Task 9
-- Требуется найти все даты года, соответствующие заданному дню недели. Сформируйте список понедельников текущего года.
SELECT Dates  
FROM (  
    SELECT Dates, TO_NUMBER(TO_CHAR(Dates, 'd')) Week_Day  
    FROM (  
        SELECT TRUNC(SYSDATE, 'yy')+level-1 Dates  
        FROM DUAL  
        CONNECT BY level <= 366  
    )  
)  
WHERE Week_Day = 2;

-- Task 10
-- Требуется создать календарь на текущий месяц. Календарь должен иметь семь столбцов в ширину и пять строк вниз.
WITH X AS (  
    SELECT *   
    FROM (  
        SELECT   
            TRUNC(SYSDATE, 'mm')+level-1 Month_Date,  
            TO_CHAR(TRUNC(SYSDATE, 'mm')+level-1, 'iw') Week_Number,  
            TO_CHAR(TRUNC(SYSDATE, 'mm')+level-1, 'dd') Day_Number,  
            TO_NUMBER(TO_CHAR(TRUNC(SYSDATE, 'mm')+level-1, 'd')) Week_Day,  
            TO_CHAR(TRUNC(SYSDATE, 'mm')+level-1, 'mm') Curr_Month,  
            TO_CHAR(SYSDATE, 'mm') Month_Number  
        FROM DUAL  
        CONNECT BY level <= 31  
    )        
    WHERE Curr_Month = Month_Number  
)  
SELECT   
    MAX(CASE Week_Day WHEN 2 THEN Day_Number END) Mo,  
    MAX(CASE Week_Day WHEN 3 THEN Day_Number END) Tu,  
    MAX(CASE Week_Day WHEN 4 THEN Day_Number END) We,  
    MAX(CASE Week_Day WHEN 5 THEN Day_Number END) Th,  
    MAX(CASE Week_Day WHEN 6 THEN Day_Number END) Fr,  
    MAX(CASE Week_Day WHEN 7 THEN Day_Number END) Sa,  
    MAX(CASE Week_Day WHEN 1 THEN Day_Number END) Su  
FROM X  
GROUP BY Week_Number  
ORDER BY Week_Number


