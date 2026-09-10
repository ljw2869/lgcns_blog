-- SQL Day 01

USE lgcns;

SHOW DATABASES ;

DESC country;

SELECT emp_id
		,emp_name
FROM employee;

SELECT * 
FROM job;

SELECT * 
FROM department;

-- Q) 부서번호가 90번인 사람의 모든 정보를 검색한다면? 
SELECT *
FROM employee
WHERE DEPT_ID='90';

-- NULL 처리함수: IFNULL(NULL,'XXX'), NULLIF(100,'NOT NULL')
SELECT IFNULL(NULL, '포세이돈의 아들은 외눈박이 돌연변이'),
		NULLIF(100,0);

SELECT EMP_NAME,
		SALARY,
		(SALARY+(SALARY * IFNULL(BONUS_PCT,0)))*12 AS `(연봉)`
FROM employee;

SELECT DISTINCT DEPT_ID, JOB_ID
FROM 	employee;

-- WHERE
--연산자(비교(lIKE, NOT LIKE), 산술, 논리(AND, OR,NOT))
SELECT *
FROM 	employee;

-- Q) 부서번호가 90번이거나 급여가 400000 이상인 사원이 모든 정보를 검색한다면?

SELECT *
FROM  	employee
WHERE DEPT_ID='90' OR SALARY>4000000;

-- CONCAT : 연결연산자
SELECT CONCAT('임정섭 ','강사님은 ','점심을 ','먹었을까?');

SELECT CONCAT(EMP_NAME,'님의 급여는 ',SALARY,'(원)입니다.')AS 급여정보
FROM employee;

-- 급여가 3500000 이상 5500000이하인 사원의 이름, 급여, 직급을 검색한다면?
SELECT EMP_NAME, SALARY,JOB_ID
FROM employee
WHERE SALARY>=3500000 AND SALARY<=5500000;

SELECT EMP_NAME, SALARY,JOB_ID
FROM employee
WHERE SALARY BETWEEN 3500000 AND 5500000;

-- Q) 김 씨 성을 가진 사원의 모든 정보를 가져온다면? 

SELECT *
FROM employee
WHERE EMP_NAME NOT LIKE "김%";


-- Q) 메일아이디 중 _ 앞자리가 3자리인 사원의 정보를 검색한다면?
SELECT *
FROM employee
WHERE EMAIL LIKE '___\_%';

-- Q) 부서배치를 받지 않은 사원의 정보를 검색한다면?
SELECT *
FROM employee
WHERE DEPT_ID IS NULL;

SELECT *
FROM employee
WHERE ISNULL(DEPT_ID);

-- Q) 부서번호가 60번이가너 90번인 사원의 정보를 검색한다면?
-- OR, IN 
SELECT *
FROM employee
WHERE DEPT_ID ='60' OR DEPT_ID ='90';

SELECT *
FROM employee
WHERE DEPT_ID IN ('60','90');

SELECT * 
FROM tb_department
-- WORKBOOK (BASIC) : 문제풀이 진행 ~~~
-- Q1) 춘 학교의 학과이름과 계열을 표시하시오. 출력헤더는 "학과명", "계열"

SELECT DEPARTMENT_NAME AS "학과 명", CATEGORY AS "계열"
FROM tb_department

-- Q2) 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT CONCAT(DEPARTMENT_NAME,'의 정원은 ',CAPACITY,'명 입니다.') AS "학과별 정원"
FROM tb_department

-- Q3)국어국문학과 여학생중 휴학중인 학생 찾아라.
SELECT *
FROM tb_student S
WHERE S.ABSENCE_YN='Y'
	AND S.DEPARTMENT_NO=
		(SELECT D.DEPARTMENT_NO 
			FROM  tb_department D 
			WHERE D.DEPARTMENT_NAME='국어국문학과')
	AND S.STUDENT_SSN LIKE '%-2%';
	
	
-- Q4) 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시
-- 학번: A513079, A513090, A513091, A513110, A513119 
SELECT STUDENT_NAME
FROM tb_student 
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');


--Q5)입학 정원이 20명 이상 30명 이하인 학과들의 학과이름과 계열출력

SELECT DEPARTMENT_NAME, CATEGORY
FROM tb_department
WHERE CAPACITY BETWEEN 20 AND 30;

--Q6)총장을 제외하고 모든 교수들이 소속 학과를 가지고 있는데 춘 기술대학교 총장의 이름을 알아내시오
SELECT PROFESSOR_NAME
FROM tb_professor
WHERE DEPARTMENT_NO IS NULL;

--Q7) 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인
SELECT *
FROM tb_student S 
WHERE S.DEPARTMENT_NO 
	NOT IN (SELECT DEPARTMENT_NO FROM tb_department);

--Q8) 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회

SELECT CLASS_NO
FROM tb_class 
WHERE PREATTENDING_CLASS_NO IS NOT NULL;


--Q9) 어떤 계열(CATEGORY)들이 있는지 조회
SELECT DISTINCT CATEGORY
FROM tb_department

-- Q10) 02학번 젂주 거주자들의 모임
-- 재학중인 학생들의 학번, 이름, 주민번호를 출력
SELECT STUDENT_NO,STUDENT_NAME,STUDENT_SSN
FROM tb_student S 
WHERE ENTRANCE_DATE LIKE '2002%'
	AND ABSENCE_YN='N'
	AND STUDENT_ADDRESS LIKE '전주%';
	
