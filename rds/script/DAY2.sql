-- Day 02
SELECT LENGTH('이지원'),
 LENGTH('jwlee'),
 CHAR_LENGTH('이지원'),
 UPPER('lgcns'),
 LOWER('LGCNS');
 

 
SELECT emp_name,LENGTH(emp_name)
FROM employee;

SELECT LENGTH(TRIM('   ddd   ')),
		LENGTH(LTRIM('   ddd   ')),
		LENGTH(RTRIM('   ddd   '));
		
--문자열을 채우는 함수 : LPAD, RPAD
--문자열, 자리수, 채울 문자들
SELECT LPAD('5','3','A')
			,LENGTH(LPAD('5','3',' '));
SELECT RPAD('5','3','A')
			,LENGTH(RPAD('5','3',' '));


SELECT EMAIL, LENGTH(EMAIL),LPAD(EMAIL,20,'#')
FROM employee;

SELECT CHAR(65);

-- SUBSTRING: 부분문자열을 반환하는 함수 (LEFT, RIGHT)
SELECT SUBSTRING('ABCDEF',1,2),
			LEFT('ABCDEF',2),
			RIGHT('ABCDEF',2);
			
SELECT SUBSTRING('THIS IS INSPIRE CAMP' FROM 9 FOR 7)
      ,SUBSTRING('THIS IS INSPIRE CAMP', 9, 7)
      ,SUBSTRING_INDEX('WWW.LGCNS.COM','.',1);

-- INSTR: 문자열을 이용해서 부분문자열의 인덱스를 반환
SELECT INSTR('LGCNS CAMP','LG');

-- HINT)함수는 함수를 중첩할 수 있다.
-- Q) . 앞의 문자 'c' 인덱스 번지를 검색
SELECT EMAIL,INSTR(EMAIL,'c.com'),LEFT(EMAIL,INSTR(EMAIL,'@')-1)
FROM employee;
-- Q) 메일 아이디만 추출

-- 문자열 반복
SELECT REPEAT('LGCNS',3),
		REPLACE('오늘은 즐거운 함수 수업','함수','메서드');
		
-- 입사 연도만 추출
SELECT LEFT(HIRE_DATE,INSTR(HIRE_DATE,'-')-1) AS '입사연도'
FROM employee;

SELECT SUBSTRING(EMPLOYEE.HIRE_DATE FROM 1 FOR 4) AS '입사년도'
FROM employee;

SELECT SUBSTRING(EMPLOYEE.HIRE_DATE,1 , 4) AS '입사년도'
FROM employee;

-- 주민번호 뒷자리 마스킹
SELECT CONCAT(LEFT(EMP_NO,8),'******')

-- CASTING: CAST(TYPE AS TYPE)
SELECT SUBSTRING(EMP_NO,1,6),
			SUBSTRING(EMP_NO, 8,7),
			SUBSTRING(EMP_NO,1,6)+SUBSTRING(EMP_NO, 8,7),
			CAST(SUBSTRING(EMP_NO,1,6) AS INT)+CAST(SUBSTRING(EMP_NO, 8,7) AS INT)
FROM employee;

USE SQLDB;
SELECT *
FROM usertbl;
SELECT *
FROM buytbl;


-- 고객의 평균 구매 개수를 검색한다면?
SELECT CAST(AVG(AMOUNT) AS INT)
		,CAST(AVG(AMOUNT) AS SIGNED INTEGER)
FROM buytbl;


-- Q) 구매번호, 총 금액(PRICE*AMOUNT), 구매액을 검색한다면? 
-- CAST()함수 사용
SELECT NUM AS '구매번호'
		,CONCAT(CAST(PRICE AS VARCHAR(10)),'*',CAST(AMOUNT AS VARCHAR(10)),' = ') AS '총금액'
		,PRICE*AMOUNT AS '구매액'
FROM buytbl;


-- 숫자 함수
SELECT ABS(-100),
		CEILING(4.7),
		FLOOR(4.1),
		FLOOR(4.7),
		ROUND(4153.415354,2),
		TRUNCATE(4153.415354,2),
		GREATEST(10, 20, 30),
		LEAST(-10, 20, 30);
--날짜 함수
SELECT NOW(),
		SYSDATE(),
		CURDATE(),
		CURTIME(),
		ADDDATE(CURDATE(),INTERVAL 30 YEAR),
		ADDDATE(CURDATE(),INTERVAL 2 MONTH),
		ADDDATE(CURDATE(),INTERVAL 2 DAY),
		SUBDATE(NOW(), INTERVAL 30 DAY),
		SUBTIME(NOW(),'13:00:00');
		
--날짜 타입 칼럼에 연산?
SELECT  HIRE_DATE,
			CAST(HIRE_DATE+1 AS DATE)
FROM employee;

-- Q) 입사일을 기준으로 근속년수가 30년이 되는 일자를 검색한다면?
SELECT  HIRE_DATE,
			ADDDATE(HIRE_DATE,INTERVAL 30 YEAR)
FROM employee;

-- Q) 오늘 날짜를 기준으로 근속년수가 30년이상인 사원의 모든 정보를 검색한다면?
SELECT DATEDIFF(CURDATE(),'2026-01-01');
-- 힌트: 일 단위

SELECT  * ,CAST(DATEDIFF(CURDATE(),HIRE_DATE)/365 AS INT ) AS '근속연수'
FROM employee
WHERE DATEDIFF(CURDATE(),HIRE_DATE)/365  >=30;


-- D DEFINITION L
DROP TABLE COUPON_TBL;
CREATE TABLE COUPON_TBL(
	CREATE_AT DATE,
	END_AT DATE
);

SELECT *
FROM COUPON_TBL;

-- DML
INSERT INTO COUPON_TBL(CREATE_AT, END_AT)
	VALUES(NOW(),ADDDATE(NOW(),INTERVAL 7 DAY));

SELECT *
FROM COUPON_TBL;

SELECT HIRE_DATE,
			SUBSTRING(HIRE_DATE,1,4),
			CAST(YEAR(HIRE_DATE)AS CHAR),
			CAST(MONTH(HIRE_DATE)AS CHAR),
			CAST(DAY(HIRE_DATE)AS CHAR),
			CAST(MINUTE(HIRE_DATE)AS CHAR),
			CAST(SECOND(HIRE_DATE)AS CHAR)
FROM employee;

SELECT WEEKDAY(NOW()), DAYOFWEEK(NOW());

-- 기타함수
--흐름 제어함수(IF, IFNULL, NULLIF, CASE~ WHEN ~ THEN~END)
SELECT IF(100>200,'TRUE','FALSE');
SELECT CASE 10
			WHEN 1 THEN '1'
			WHEN 2 THEN '2'
			ELSE '없음'
			END AS '구분';
			
-- 성별
-- Q) 부서번호가 50번인 사원의 이름, 주민번호, 성별 검색한다면?
SELECT EMP_NAME, EMP_NO,IF(CAST(SUBSTRING(EMP_NO,8,1)AS INT)%2=1,'남자','여자') AS 'GENDER'
FROM employee
WHERE DEPT_ID=50;

--왜 아래 코드가 오류가 날까? 
SELECT EMP_NAME, 
		EMP_NO,
		CASE SUBSTRING(EMP_NO,8,1)
			WHEN '1' OR '3' THEN '남자'
			WHEN '2' OR '4' THEN '여자'
			ELSE '?'
		END AS 'GENDER'
FROM EMPLOYEE
WHERE DEPT_ID=50;

SELECT EMP_NAME, 
		EMP_NO,
		CASE WHEN SUBSTRING(EMP_NO,8,1) IN('1','3') THEN '남자'
				WHEN SUBSTRING(EMP_NO,8,1) IN('2','4') THEN '여자'
		ELSE '?'
		END AS 'GENDER'
FROM EMPLOYEE
WHERE DEPT_ID=50;


--Q) 사원테이블에서 직급(JOB_ID)이 'J4'인 사원의 이름, 사번, 사수번호(MGR)검색한다면? 
-- 조건) 사수번호가 없는 사원은 관리자 직급-> MGR_ID칼럼에 '관리자' 출력
SELECT EMP_NAME, EMP_ID, IF(MGR_ID='','관리자',MGR_ID)
FROM employee
WHERE JOB_ID='J4';

-- Q) 급여등급을 나눠보고 싶다
-- 300 이하면 초급, 400 이하면 중급, 초과하면 고급
-- 사원번호, 이름, 급여, 급여등급 검색한다면?
SELECT EMP_ID, EMP_NAME, SALARY,
	CASE 
		WHEN SALARY<=3000000 THEN '초급'
		WHEN SALARY<=4000000 THEN '중급'
		ELSE '고급'
		END AS '급여 등급'
FROM employee;


-- Q) 남자 사원에 대한 정보만 출력?
SELECT EMP_NAME, 
			EMP_NO,
			'남자'AS GENDER
FROM employee
WHERE SUBSTRING(EMP_NO,8,1)='1';

-- 복수행 함수 
-- 여러행의 결과를 입력으로 해서 하나 또는 그 이상의 결과를 반환
-- WHERE 절에는 복수행 함수 x
-- SELECT절에서는 사용가능하나, 일반칼럼은 사용할 수 없음 

SELECT 	COUNT(*),
			COUNT(IFNULL(BONUS_PCT,0)),
			MIN(SALARY),
			MAX(SALARY),
			AVG(SALARY),
			SUM(SALARY)
FROM employee;

-- ORDER BY [기준칼럼| 표현식| 칼럼인덱스| 칼럼 별칭]ASC | DESC
SELECT EMP_ID, EMP_NAME, SALARY,
	CASE 
		WHEN SALARY<=3000000 THEN '초급'
		WHEN SALARY<=4000000 THEN '중급'
		ELSE '고급'
		END AS '급여 등급'
FROM employee
ORDER BY SALARY DESC;

-- WORKBOOK SELECT함수
--Q1) 영어영문학과(학과코드002) 학생들 학번, 이름, 입학 년도를 입학 년도가 빠른 순으로 표시
SELECT STUDENT_SSN AS '학번', STUDENT_NAME  AS '이름', ENTRANCE_DATE AS '입학 년도'
FROM tb_student
WHERE DEPARTMENT_NO='002'
ORDER BY ENTRANCE_DATE;

--Q2) 교수 중 이름이 세 글자가 아닌 그 교수의 이름과 주민번호를 화면에 출력
SELECT PROFESSOR_NAME,PROFESSOR_SSN
FROM tb_professor
WHERE CHAR_LENGTH(PROFESSOR_NAME) <> 3;

--Q3) 남자 교수들의 이름과 나이를 출력(나이가 적은 사람에서 많은 사람 순서로)

SELECT PROFESSOR_NAME AS '교수 이름' ,YEAR(CURDATE())-CAST(CONCAT('19',SUBSTRING(PROFESSOR_SSN,1,2))AS INT) AS '나이'
FROM tb_professor
WHERE SUBSTRING(PROFESSOR_SSN,8,1) IN ('1','3')
ORDER BY '나이';

--Q4)교수들의 이름 중 성을 제외한 이름만 출력
SELECT SUBSTRING(PROFESSOR_NAME,2) AS '이름'
FROM tb_professor;

--Q5)재수생 입학자, 19살에 입학하면 재수를 하지 않은 것으로
SELECT STUDENT_NO, STUDENT_NAME
FROM tb_student
WHERE YEAR(ENTRANCE_DATE)-CAST(CONCAT('19',SUBSTRING(STUDENT_SSN,1,2))AS INT)>19;

--Q6)2020년 크리스마스는 무슨 요일인가?
-- WEEKDAY(0~월)
-- DAYOFWEEK(1~일)
SELECT CASE WEEKDAY('2020-12-25')
				WHEN 0 THEN '월요일'
				WHEN 1 THEN '화요일'
				WHEN 2 THEN '수요일'
				WHEN 3 THEN '목요일'
				WHEN 4 THEN '금요일'
				WHEN 5 THEN '토요일'
				ELSE '일요일'
				END AS '2020년 크리스마스 요일'
SELECT DAYNAME('2020-12-25');
				
--Q8) 2000년도 이전 학번을 받은 학생들의 학번과 이름 출력
SELECT STUDENT_NO, STUDENT_NAME
FROM tb_student
WHERE LEFT(STUDENT_NO,1)<>'A';

--Q9) 학번이 A517178 인 한아름 학생의 학점 총 평점(점수는 반올림하여 소수점 이하 한 자리까지)
SELECT ROUND(AVG(G.POINT),1) AS 평점
FROM tb_student S, tb_grade G
WHERE S.STUDENT_NAME='한아름' AND S.STUDENT_NO=G.STUDENT_NO;

--Q11) 지도 교수를 배정받지 못한 학생의 수
SELECT COUNT(*)
FROM tb_student 
WHERE ISNULL(COACH_PROFESSOR_NO) ;

---부가적으로 해보기
--Q7) 
SELECT TO_DATE('99/10/11','YY/MM/DD'),
		TO_DATE('49/10/11','YY/MM/DD'),
		TO_DATE('99/10/11','RR/MM/DD'),
		TO_DATE('49/10/11','RR/MM/DD');
		
--Q10) 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더
SELECT DEPARTMENT_NO AS '학과번호', COUNT(DEPARTMENT_NO) AS '학생수(명)'
FROM tb_student 
GROUP BY DEPARTMENT_NO;

--Q12)A112113인 김고운 학생의 년도 별 평점(점수는 반올림하여 소수점 이하 한 자리까지)
SELECT SUBSTRING(G.TERM_NO,1,4) AS '년도', ROUND(AVG(G.POINT),1) AS '년도 별 평점'
FROM tb_student S, tb_grade G
WHERE S.STUDENT_NAME='김고운' AND S.STUDENT_NO=G.STUDENT_NO
GROUP BY SUBSTRING(G.TERM_NO,1,4);
--위의 2002년도 평점이 조금 다르게 나옴? 



--Q13) 학과 별 휴학생 수:학과 번호와 휴학생 수를 표시
SELECT DEPARTMENT_NO AS '학과번호', 
       COUNT(IF(ABSENCE_YN = 'Y', 1, NULL)) AS '휴학생 수'
FROM tb_student
GROUP BY DEPARTMENT_NO;
-- 만약 1,0으로 넣었다면
-- 재학생이어도 NULL은 아니기때문에 결국 각 학과의 학생수를 집계하는 상황이 되어버림
-- OR 

SELECT DEPARTMENT_NO AS '학과번호', 
       SUM(IF(ABSENCE_YN = 'Y', 1, 0)) AS '휴학생 수'
FROM tb_student
GROUP BY DEPARTMENT_NO;

--Q14)동명이인(同名異人) 학생들의 이름을 출력하라

SELECT STUDENT_NAME AS '동일이름', COUNT(*) AS '동명인 수'
FROM tb_student
GROUP BY STUDENT_NAME
HAVING COUNT(*)>=2;

--Q15) A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점

