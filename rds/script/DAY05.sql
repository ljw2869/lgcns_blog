-- DAY05 (DDL & DML)
USE TABLEDB;

-- FOREIGN KEY: 참조 무결성 (부모에 의존하는 데이터 또는 NULL)
-- 삽입, 갱신, 삭제 이상을 방지하기 위해 RESTRICT가 기본인데, 외래키 옵션을 줄 수 있음
-- 외래키 옵션 (권장X)
-- ON DELECT CASCADE, ON UPDATE CASECADE
-- ON DELECT NO ACTION, ON UPDATE NO ACTION

CREATE TABLE TB_JOB(
	JOB_ID 		VARCHAR(10),
	JOB_TITLE 	VARCHAR(50),
	PRIMARY KEY (JOB_ID)
);

INSERT INTO TB_JOB(JOB_ID,JOB_TITLE)
VALUES('J1','대표');

INSERT INTO TB_JOB(JOB_ID,JOB_TITLE)
VALUES('J2','상무');

SELECT *
FROM TB_JOB;

SHOW INDEX FROM TB_JOB; -- 제약 조건 확인 가능

CREATE TABLE TB_DEPT(
	DEPT_ID	VARCHAR(10),
	DEPT_TITLE VARCHAR(50),
	PRIMARY KEY(DEPT_ID)
);

INSERT INTO TB_DEPT(DEPT_ID,DEPT_TITLE)
VALUES('10','교육팀');

INSERT INTO TB_DEPT(DEPT_ID,DEPT_TITLE)
VALUES('20','운영팀');

SELECT *
FROM TB_DEPT;

SHOW INDEX FROM TB_DEPT;

CREATE TABLE TB_EMP(
	EMP_ID 		VARCHAR(10) PRIMARY KEY,  -- 문자가 고정길이를 가질 때 CHAR를 쓸 수 있음
	EMP_NAME 	VARCHAR(50) NOT NULL,
	HIRE_DATE 	DATE        DEFAULT SYSDATE(),
	DEPT_ID 		VARCHAR(10) NOT NULL,
	JOB_ID 		VARCHAR(10) NOT NULL,
	FOREIGN KEY(DEPT_ID) REFERENCES TB_DEPT(DEPT_ID) ON DELETE CASCADE,
	FOREIGN KEY(JOB_ID)  REFERENCES TB_JOB(JOB_ID) ON UPDATE CASCADE
);

SHOW INDEX FROM TB_EMP;
-- ERROR
INSERT INTO TB_EMP(EMP_ID, EMP_NAME, DEPT_ID,JOB_ID)
VALUES('100','JSLIM',NULL,NULL);

INSERT INTO TB_EMP(EMP_ID, EMP_NAME, DEPT_ID,JOB_ID)
VALUES('100','JSLIM','30','J3');

-- OKAY
INSERT INTO TB_EMP(EMP_ID, EMP_NAME, DEPT_ID,JOB_ID)
VALUES('100','JSLIM','10','J1');

SELECT * 
FROM TB_EMP;

INSERT INTO TB_EMP(EMP_ID, EMP_NAME,HIRE_DATE, DEPT_ID,JOB_ID)
VALUES('200','JSLIM',DEFAULT,'10','J1');

INSERT INTO TB_EMP(EMP_ID, EMP_NAME,HIRE_DATE, DEPT_ID,JOB_ID)
VALUES('300','JSLIM',NULL,'10','J1');
-- DEFAULT가 들어가도 명시적 NULL이 들어가면 DEFAULT값으로 채워주지 않음

DELETE FROM TB_DEPT
WHERE DEPT_ID='10';

SELECT * 
FROM TB_DEPT;

SELECT * 
FROM TB_EMP;
-- DELETE CASECADE라서 위의 EMP테이블도 10번 부서를 담았기 때문에 모두 삭제됨

-- SELF RECURSIVE 만들기
DROP TABLE IF EXISTS TB_EMPLOYEE;
CREATE TABLE TB_EMPLOYEE(
	EMP_ID VARCHAR(10),
	EMP_NAME VARCHAR(20) NOT NULL,
	SALARY INT CHECK(SALARY>0),
	GENDER CHAR(1) CHECK (GENDER IN('F','M')),
	HIRE_DATE DATE DEFAULT SYSDATE(),
	JOB_ID VARCHAR(10),
	DEPT_ID VARCHAR(10)
);

SHOW INDEX FROM TB_EMPLOYEE; -- 제약을 보는 거긴 하지만 실제로 인덱스가 있어야 함.
-- 기본키는 인덱스를 걸지 않더라도 알아서 걸리는 거라 NOT NULL이나 다른 제약조건은 볼 수 없음
SELECT *
FROM TB_EMPLOYEE;

-- 테이블 스키마 수정 및 제약조건 추가, 변경
-- ALTER TABLE ~ 
--  	ADD, DROP CONSTRAINT
--    ADD COLUMN
--    CHANGE COLUMN OLD NEW  INT 로 이름 변경과 타입 변경 동시에 가능
--    MODIFY COLUMN OLD INT -- 타입 변경
-- 데이터 없는 상태에서는 타입 변경 가능
--		DROP COLUMN COLUMN_NAME
-- RENAME -- 테이블 이름 변경


ALTER TABLE TB_EMPLOYEE
ADD CONSTRAINT PRIMARY KEY(EMP_ID);

SHOW INDEX FROM TB_EMPLOYEE;

-- Q) JOB_ID와 DEPT_ID칼럼에 ALTER명령어 이용해서 NOT NULL, FOREIGN KEY 추가 
ALTER TABLE TB_EMPLOYEE
ADD CONSTRAINT FOREIGN KEY(JOB_ID) REFERENCES TB_JOB(JOB_ID);

ALTER TABLE TB_EMPLOYEE
ADD CONSTRAINT FOREIGN KEY(DEPT_ID) REFERENCES TB_DEPT(DEPT_ID);

ALTER TABLE TB_EMPLOYEE
MODIFY JOB_ID VARCHAR(10) NOT NULL;

ALTER TABLE TB_EMPLOYEE
MODIFY DEPT_ID VARCHAR(10) NOT NULL;
-- NOT NULL은 테이블 레벨에서 제약을 둘 수 없고, 칼럼 레벨에서 제약을 걸어주어야 하는데
-- ADD CONSTRINT 방식은 테이블 레벨에서 제약을 주는 상황이라서 그냥 ADD CONSTRAINT로는 NOT NULL을 할 수 없다
-- MODIFY는 칼럼 레벨로 변경하는 방식이다.

SHOW INDEX FROM TB_EMPLOYEE;
-- 실무에서 테이블 제약을 관리하는 구문
SHOW CREATE TABLE TB_EMPLOYEE;

-- 실제 DBMS에서 관리하는 제약확인
SELECT 	CONSTRAINT_NAME, 
			constraint_type, 
			table_name
FROM 		information_schema.table_constraints
WHERE 	table_schema = 'TABLEDB'
AND 		table_name = 'TB_EMPLOYEE';


/*
VIEW : 가상이 논리적 테이블(읽기 전용)
- 보안 및 질의어 단순화
CREATE OR REPLACE VIEW VIEW_NAME(ALIAS)
AS SUBQUERY ;
*/

USE LGCNS;
CREATE OR REPLACE VIEW EMP_VIEW(NAME, DEPT)
AS 
SELECT E.EMP_NAME, D.DEPT_NAME
FROM DEPARTMENT D
JOIN EMPLOYEE E ON (D.DEPT_ID=E.DEPT_ID)
WHERE E.DEPT_ID='90';

SELECT * FROM EMP_VIEW;

-- WORKBOOK DDL (1~15)
-- Q1) 계열 정보를 저장할 카테고리 테이블 만들기
USE LGCNS;
DROP TABLE IF EXISTS TB_CATEGORY;

CREATE TABLE TB_CATEGORY(
	NAME VARCHAR(10),
	USE_YN CHAR(1) DEFAULT 'Y'
);

-- Q2) 과목 구분을 저장할 테이블
DROP TABLE IF EXISTS TB_CLASS_TYPE;
CREATE TABLE TB_CLASS_TYPE(
	NO VARCHAR(5) PRIMARY KEY,
	NAME VARCHAR(10)
);

-- Q3) TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
ALTER TABLE TB_CATEGORY
ADD CONSTRAINT PRIMARY KEY (NAME);

-- Q4) TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경
ALTER TABLE TB_CLASS_TYPE
MODIFY COLUMN NAME VARCHAR(10) NOT NULL;

-- Q5) 두 테이블에서 컬럼 명이 NO인 것은 기존 타입을 유지하면서 크기는 10 으로, 
-- 컬럼명이 NAME 인 것은 로 기존 타입을 유지하면서 크기 20 으로 변경
ALTER TABLE TB_CLASS_TYPE
MODIFY COLUMN NO VARCHAR(10);

ALTER TABLE TB_CLASS_TYPE
MODIFY COLUMN NAME VARCHAR(20);

ALTER TABLE TB_CATEGORY
MODIFY COLUMN NAME VARCHAR(20);

-- Q6) 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각각 
-- TB_ 를 제외한 테이블 이름이 앞에 붙은 형태로 변경
ALTER TABLE TB_CLASS_TYPE
CHANGE COLUMN NO CLASS_TYPE_NO VARCHAR(10);

ALTER TABLE TB_CLASS_TYPE
CHANGE COLUMN NAME CLASS_TYPE_NAME VARCHAR(20);

ALTER TABLE TB_CATEGORY
CHANGE COLUMN NAME CATEGORY_NAME VARCHAR(20);

-- Q7)TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 변경
-- Primary Key의 이름은 ‚PK_ + 컬럼이름‛으로 지정
ALTER TABLE TB_CLASS_TYPE
DROP PRIMARY KEY;

ALTER TABLE TB_CLASS_TYPE
ADD CONSTRAINT PK_CLASS_TYPE_NO
PRIMARY KEY (CLASS_TYPE_NO);
-- 결과 확인
SHOW INDEX FROM TB_CLASS_TYPE;


--카테고리도 동일하게
ALTER TABLE TB_CATEGORY
DROP PRIMARY KEY;

ALTER TABLE TB_CATEGORY
ADD CONSTRAINT PK_CATEGORY_NAME
PRIMARY KEY(CATEGORY_NAME);

-- 간단한 방식-- 위의 코드를 다음과 같이 한번에 묶어서 가능
ALTER TABLE tb_category
	DROP CONSTRAINT PRIMARY KEY.
	ADD CONSTRAINT PK_CATEGORY_NAME PRIMARY KEY (CATEGORY_NAME);
	
ALTER TABLE tb_class_type
	DROP CONSTRAINT PRIMARY KEY,
	ADD CONSTRAINT PK_CLASS_TYPE_NO PRIMARY KEY (CLASS_TYPE_NO);

-- Q8) INSERT 문을 수행
INSERT INTO TB_CATEGORY VALUES 
('공학','Y'),
('자연과학','Y'),
('의학','Y'),
('예체능','Y'),
('인문사회','Y'); 
COMMIT;

SELECT *
FROM TB_CATEGORY;

-- Q9)TB_DEPARTMENT의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모 값으로 참조하도록 FOREIGN KEY를 지정
-- 이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정 (ex. FK_DEPARTMENT_CATEGORY )
ALTER TABLE tb_department
ADD CONSTRAINT FK_DEPARTMENT_CATEGORY
FOREIGN KEY(CATEGORY) 
REFERENCES TB_CATEGORY(CATEGORY_NAME);

-- Q10) 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 생성
CREATE OR REPLACE VIEW VW_학생일반정보(학번, 학생이름,주소)
AS 
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
FROM tb_student;

SELECT *
FROM VW_학생일반정보;

-- Q11) 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행
-- 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW

CREATE OR REPLACE VIEW VW_지도면담(학생이름,학과이름,지도교수이름)
AS
SELECT S.STUDENT_NAME, D.DEPARTMENT_NAME, P.PROFESSOR_NAME
FROM tb_student S
LEFT JOIN tb_professor P ON(S.COACH_PROFESSOR_NO=P.PROFESSOR_NO)
JOIN tb_department D ON (D.DEPARTMENT_NO=S.DEPARTMENT_NO);
-- 만약 지도교수가 없는 학생도 보여지게 하고 싶다면 교수와의 JOIN을 LEFT JOIN으로 바꿔라
SELECT *
FROM VW_지도면담;

-- Q12)모든 학과의 학과별 학생 수를 확인할 수 있도록 VIEW 작성
CREATE OR REPLACE VIEW VW_학과별학생수(DEPARTMENT_NAME, STUDENT_COUNT)
AS
SELECT D.DEPARTMENT_NAME, COUNT(S.DEPARTMENT_NO)
FROM tb_student S
JOIN tb_department D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
GROUP BY D.DEPARTMENT_NO;

SELECT *
FROM VW_학과별학생수;

-- Q13) 위에서 생성한 학생일반정보 View를 통해서 학번이 A213046인 학생의 이름을 본인 이름으로 변경
UPDATE VW_학생일반정보
SET 학생이름='이지원'
WHERE 학번='A213046';

SELECT *
FROM VW_학생일반정보;

-- Q14) 

CREATE OR REPLACE VIEW VW_학생일반정보(학번, 학생이름,주소)
AS 
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
FROM tb_student
WHERE 1=1
WITH CHECK OPTION;

-- Q15) 2009년 기준 수강인원이 가장 많았던 3과목
SELECT C.CLASS_NO   AS 과목번호,
       C.CLASS_NAME AS 과목이름,
       COUNT(*)     AS `누적수강생수(명)`
FROM TB_CLASS C
JOIN TB_GRADE G
  ON (C.CLASS_NO = G.CLASS_NO)
WHERE SUBSTRING(G.TERM_NO, 1, 4)
      BETWEEN '2007' AND '2009'
GROUP BY C.CLASS_NO,
         C.CLASS_NAME
ORDER BY COUNT(*) DESC,
         C.CLASS_NO
LIMIT 3;

-- DROP TABLE TABLE_NAME;
-- DROP VIEW VIEW_NAME;

-- DML: DATA MANIPULATION LANGUAGE
-- UPDATE, INSERT, DELECT => TRANSACTION(COMMIT,ROLLBACK)=작업의 단위 발생
/*
UPDATE TABLE_NAME
SET	 COLUMN_NAME={VALUE | SUBQUERY | [DEFAULT]}
WHERE	 CONDITION = {VALUE | SUBQUERY};
*/

SELECT *
FROM department;

UPDATE department
SET DEPT_NAME='전략기획팀'
WHERE DEPT_ID='90';

ROLLBACK;-- 바뀌지 않음 여기서는 기본적으로 DML이 AUTOCOMMIT임

-- 심하균의 직급과 부서을 성해교 사원과 같은 직급과 부서로 수정한다면?
SELECT EMP_NAME, DEPT_ID, JOB_ID
FROM employee
WHERE EMP_NAME='심하균' OR EMP_NAME='성해교'; -- NULL, 50

-- ERROR
UPDATE EMPLOYEE
SET (DEPT_ID,JOB_ID)=(SELECT E.DEPT_ID, E.JOB_ID FROM employee E WHERE EMP_NAME='성해교')
WHERE EMP_NAME='심하균';

-- 각각 업데이트 해야 함
UPDATE EMPLOYEE
SET DEPT_ID = (
        SELECT E.DEPT_ID
        FROM EMPLOYEE E
        WHERE E.EMP_NAME = '성해교'
    ),
    JOB_ID = (
        SELECT E.JOB_ID
        FROM EMPLOYEE E
        WHERE E.EMP_NAME = '성해교'
    )
WHERE EMP_NAME = '심하균';

-- Q) 한선기 대표를 돌싱으로 만들어본다면?
UPDATE employee
SET MARRIAGE=DEFAULT -- 이렇게 디폴트값을 넣을 수 있음
WHERE EMP_NAME='한선기';

SELECT * 
FROM employee;

-- UPDATE시 데이터의 무결성을 고민해야 한다. 
-- ERROR
UPDATE employee
SET DEPT_ID='65' 
WHERE EMP_ID='100';
-- DEPT_ID인 외래키의 칼럼을 수정할 때, 참조하는 테이블에 있는 값이거나 NULL을 허용함

-- WHERE 절에 서브쿼리 가능함
-- Q) 해외영업 2팀(80)의 사원의 보너스 비율을 0.3으로 수정하고 싶다면?
UPDATE employee
SET BONUS_PCT = 0.3
WHERE DEPT_ID=(SELECT D.DEPT_ID FROM department D WHERE D.DEPT_NAME='해외영업2팀');

-- INSERT : 데이터를 추가
/*
데이터 타입, 순서, 개수가 잘 맞아야 함
INSERT INTO TABLE_NAME([COLUMN_NAME]) VALUES(VALUES);
무결성 쪽은 조금 생각해주기
*/

SELECT *
FROM employee;

-- DELETE: 테이블에 포함된 데이터 삭제(전체 행 수가 달라짐)
/*
DELETE FROM TABLE_NAME
WHERE CONDITION
데이터 무결성은 생각해 볼 필요 있음: 부모의 데이터를 삭제할 때 자식이 참조하고 있다면
*/
-- ERROR : 한선기가 90번 부서에 있기 때문에 지울 수 없음
DELETE FROM department
WHERE DEPT_ID='90';

-- SEQUENSE(10.~)
-- NEXTVAL(), LASTVAL()-현재 시퀀스 값을 확인할 때 사용
-- EMP_ID INT AUTO_INCREMENT PRIMARY KEY

CREATE SEQUENCE SEQ_TEST;

SELECT NEXTVAL(SEQ_TEST);-- 계속 실행시 증가, 알아서 채번, 중복될 수 없어 기본키의 값으로 쓰임
SELECT LASTVAL(SEQ_TEST);

SELECT PREVIOUS VALUE FOR SEQ_TEST; -- 기능 한번 확인해보자
DROP SEQUENCE SEQ_TEST;

CREATE SEQUENCE SEQ_TEST
	START WITH 1000 
	INCREMENT BY 2
	MAXVALUE 1005;
	-- NOCYCLE
	-- CACHE 20
	
SELECT NEXTVAL(SEQ_TEST);

CREATE TABLE TB_TEMP(
	ORDER_ID INT DEFAULT (NEXTVAL(SEQ_TEST)) PRIMARY KEY,
	CUSTOMER_NAME VARCHAR(50)
);

INSERT INTO TB_TEMP(CUSTOMER_NAME) VALUES('JSLIM'); -- 3번 실행

SELECT *
FROM TB_TEMP;

SHOW TABLES;

CREATE TABLE TB_AUTO_TEMP(
	ORDER_ID INT AUTO_INCREMENT PRIMARY KEY,
	CUSTOMER_NAME VARCHAR(50)
);

INSERT INTO TB_AUTO_TEMP(CUSTOMER_NAME)VALUES ('JSLIM');
SELECT *
FROM TB_AUTO_TEMP;


-- WORKBOOK DML 8문제 
-- Q1) 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.

SELECT * 
FROM TB_CLASS_TYPE;

INSERT INTO TB_CLASS_TYPE
VALUES('01','전공필수'),
('02','전공선택'),
('03','교양필수'),
('04','교양선택'),
('05','논문지도');

-- Q2) 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다
CREATE TABLE TB_학생일반정보(
	학번  VARCHAR(10) NOT NULL,
	이름  VARCHAR(40) NOT NULL,
	주소  VARCHAR(200),
	PRIMARY KEY (학번)
);

-- ERROR
INSERT INTO TB_학생일반정보
VALUES (SELECT S.STUDENT_NO,S.STUDENT_NAME, S.STUDENT_ADDRESS FROM tb_student S);


INSERT INTO TB_학생일반정보
SELECT S.STUDENT_NO,
       S.STUDENT_NAME,
       S.STUDENT_ADDRESS
FROM TB_STUDENT S;

SELECT*
FROM TB_학생일반정보;

-- SELECT를 사용해서 CREATE 시에 만들수 있음
CREATE TABLE TB_학생일반정보
(
	SELECT S.STUDENT_NO AS `학번`,
			 S.STUDENT_NAME AS `학생이름`,
			 S.STUDENT_ADDRESS AS `주소`
	FROM TB_STUDENT S
);


-- Q3) 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블
DROP TABLE IF EXISTS TB_국어국문학과;
USE LGCNS;
CREATE TABLE TB_국어국문학과(
	학번     VARCHAR(10),
	학생이름 VARCHAR(40) NOT NULL,
	출생년도 CHAR(4) NOT NULL,
	교수이름 VARCHAR(40),
	PRIMARY KEY (학번)
);
INSERT TB_국어국문학과
SELECT S.STUDENT_NO, S.STUDENT_NAME, CONCAT('19',LEFT(S.STUDENT_SSN,2)),P.PROFESSOR_NAME
FROM tb_student S
JOIN tb_professor P
ON(S.COACH_PROFESSOR_NO=P.PROFESSOR_NO)
JOIN tb_department D
ON(S.DEPARTMENT_NO=D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME='국어국문학과'; 

SELECT *
FROM TB_국어국문학과;

-- CREATE를 할 때 기존 테이블의 값을 복사해서 가져올 때- JOIN 필요한 상황
CREATE TABLE TB_국어국문학과(
	SELECT S.STUDENT_NO `학번`, 
			 S.STUDENT_NAME `학생이름`, 
			 CONCAT('19',LEFT(S.STUDENT_SSN,2)) `출생년도`,
			 P.PROFESSOR_NAME `교수이름`
			 
	FROM tb_student S
		JOIN tb_professor P
		ON(S.COACH_PROFESSOR_NO=P.PROFESSOR_NO)
		JOIN tb_department D
		ON(S.DEPARTMENT_NO=D.DEPARTMENT_NO)
		
	WHERE D.DEPARTMENT_NAME='국어국문학과'
	
	-- PRIMARY KEY (학번)	
);





-- Q4) 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용핛 SQL 문을 작성하시오.
UPDATE tb_department
SET CAPACITY=ROUND(CAPACITY*1.1);

-- Q5) 학번 A413042인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO='A413042';

-- 확인
SELECT STUDENT_ADDRESS
FROM tb_student
WHERE STUDENT_NO='A413042';

-- Q6) 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정
UPDATE tb_student
SET STUDENT_SSN=LEFT(STUDENT_SSN,6);

SELECT *
FROM tb_student;

-- Q7) 의학과 김명훈 학생은 2005년 1학기에 자신이 수강핚 '피부생리학' 점수 정정을 요청 
-- 담당 교수의 확인 받은 결과 해당 과목의 학점을 3.5로 변경키로 결정되었다
UPDATE tb_grade
SET POINT=3.5
WHERE TERM_NO='200501' 
AND STUDENT_NO=
		(
			SELECT S.STUDENT_NO 
			FROM tb_student S 
			WHERE S.STUDENT_NAME='김명훈'AND S.DEPARTMENT_NO=(
																				SELECT D.DEPARTMENT_NO 
																				FROM tb_department D 
																				WHERE D.DEPARTMENT_NAME='의학과')
		)
AND CLASS_NO=
		(SELECT C.CLASS_NO FROM tb_class C WHERE C.CLASS_NAME='피부생리학');
		
-- Q8)성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거

DELETE FROM tb_grade
WHERE STUDENT_NO IN (
							SELECT S.STUDENT_NO
							FROM tb_student S
							WHERE S.ABSENCE_YN='Y');
							
-- 현업에서는 DELETE를 하지 않고 NULL로 UPDATE하는 경우도 있음
UPDATE tb_grade 
SET POINT = NULL
WHERE STUDENT_NO IN (SELECT STUDENT_NO
						  FROM TB_STUDENT
						  WHERE ABSENCE_YN = 'Y');
	  

USE TABLEDB;

-- Q1-1) CUSTOMERS
CREATE TABLE CUSTOMERS(
	CNO INT(5),
	CNAME VARCHAR(10) NOT NULL,
	ADDRESS VARCHAR(50) NOT NULL,
	EMAIL VARCHAR(20) NOT NULL,
	PHONE VARCHAR(20) NOT NULL,
	PRIMARY KEY(CNO)
);

-- Q1-2) ORDERS
CREATE TABLE ORDERS(
	ORDERNO INT(10) NOT NULL,
	ORDERDATE DATE DEFAULT SYSDATE(),
	ADDRESS VARCHAR(50) NOT NULL,
	PHONE VARCHAR(20) NOT NULL,
	STATUS VARCHAR(20) NOT NULL CHECK (STATUS IN ('결제완료','배송중','배송완료')),
	CNO INT(5) NOT NULL,
	PRIMARY KEY(ORDERNO),
	FOREIGN KEY (CNO)  REFERENCES CUSTOMERS(CNO)
);

-- Q1-3) PRODUCTS
CREATE TABLE PRODUCTS(
	PNO INT(5) ,
	PNAME VARCHAR(20) NOT NULL,
	COST INT(8) DEFAULT 0 NOT NULL,
	STOCK INT(5) DEFAULT 0 NOT NULL,
	PRIMARY KEY (PNO)
);
-- Q1-4) ORDERDETAIL
CREATE TABLE ORDERDETAIL (
    ORDERNO INT(10),
    PNO INT(5),
    QTY INT(5) DEFAULT 0,
    COST INT(8) DEFAULT 0,
    
    PRIMARY KEY (ORDERNO, PNO), -- 중요
    
    FOREIGN KEY (ORDERNO)
        REFERENCES ORDERS(ORDERNO),
        
    FOREIGN KEY (PNO)
        REFERENCES PRODUCTS(PNO)
);

-- Q2) products 테이블에 다음 데이터를 입력하시오
INSERT INTO products
VALUES 
(1001,'삼양라면',1000,200),
(1002,'새우깡',  1500,500),
(1003,'월드콘',  2000,350),
(1004,'빼빼로',  2000,700),
(1005,'코카콜라',1800,550),
(1006,'환타',    1600,300);

SELECT * FROM products;

-- Q3) customers 테이블에 다음 데이터를 입력하시오.
INSERT INTO CUSTOMERS
VALUES 
(101,'김철수','서울 강남구','cskim@naver.com',  '899-6666'),
(102,'이영희','부산 서면'  ,'yhlee@empal.com',  '355-8882'),
(103,'최진국','제주 동광양','jkchoi@gmail.com', '852-5764'),
(104,'강준호','강릉 홍제동','jhkang@hanmail.com','559-7777'),
(105,'민병국','대전 전민동','bgmin@hotmail.com', '559-8741'),
(106,'오민수','광주 북구',  'msoh@microsoft.com','542-9988');

-- Q4) 
INSERT INTO orders
VALUES
(1,DATE_SUB(SYSDATE(), INTERVAL 3 DAY),'서울 강남구','899-6666','결제완료',
									(SELECT C.CNO FROM customers C WHERE C.CNAME='김철수'));
INSERT INTO orderdetail
VALUES
(1,(SELECT P.PNO FROM products P WHERE P.PNAME='삼양라면'),50,1000);


-- 확인
SELECT *
FROM orders;
SELECT *
FROM orderdetail;

-- Q5) 위와 같은 주문 정보에서 상품의 재고를 수정하시오
UPDATE products
SET STOCK=150
WHERE PNAME='삼양라면';

SELECT *
FROM products;

-- Q6) 주문 정보를 orders 테이블과 orderdetail 테이블에 입력하시오
-- cno는 customers 테이블에서 검색하여 입력할 것. 
-- orders에 1건, orderdetail에 2건을 입력한다.
INSERT INTO ORDERS
VALUES
	(2, DATE_SUB(SYSDATE(),INTERVAL 2 DAY),'부산 수영구','337-5000','결제완료',
																									(
																										SELECT C.CNO 
																										FROM customers C 
																										WHERE C.CNAME='이영희'
																									)
	);
INSERT INTO orderdetail
VALUES
(2,(SELECT PNO FROM PRODUCTS WHERE PNAME= '새우깡'),100,1500),
(2,(SELECT PNO FROM PRODUCTS WHERE PNAME= '월드콘'),150,2000);


-- Q7) 위와 같은 주문 정보에서 해당 상품(products)의 재고(stock)을 수정하시오.
-- 새우깡(1002)의 재고를 400(=500-100)개로 변경한다
--"월드콘(1003)의 재고를 200(=350-150)개로 변경한다”

UPDATE products 
SET STOCK=400
WHERE PNAME='새우깡';

UPDATE products 
SET STOCK=200
WHERE PNAME='월드콘';

-- 현재 재고와 최근 주문의 수량을 잘 모른다면 400을 도출할 수 없기 때문에 
-- SET를 P.STOCK-D.QTY로 계산해야 한다!!
-- 이게 정석적인 코드
UPDATE products P
JOIN orderdetail D USING(pno)
SET stock = P.stock-D.qty
WHERE pno =  (SELECT PNO 
				  FROM PRODUCTS 
				  WHERE PNAME = '새우깡');

UPDATE products P
JOIN orderdetail D USING(pno)
SET stock = P.stock-D.qty
WHERE pno = (SELECT PNO 
				 FROM PRODUCTS 
				 WHERE PNAME = '월드콘');

-- Q8) 

INSERT INTO ORDERS
VALUES
	(3, DATE_SUB(SYSDATE(),INTERVAL 1 DAY),'광주 북구','652-2277','결제완료',
																									(
																										SELECT C.CNO 
																										FROM customers C 
																										WHERE C.CNAME='오민수'
																									)
	);
	
INSERT INTO orderdetail
VALUES
(3,(SELECT PNO FROM PRODUCTS WHERE PNAME= '빼빼로'),100,2000),
(3,(SELECT PNO FROM PRODUCTS WHERE PNAME= '코카콜라'),50,1800);

-- Q9) 상품(products)의 재고(stock)을 수정하시오
-- 내 코드
UPDATE products 
SET STOCK=600
WHERE PNAME='빼빼로';

UPDATE products 
SET STOCK=500
WHERE PNAME='코카콜라';


-- 위와 같이 일일히 할 필요 없이 
-- 단순하게 ORDERNO가 3인 것들을 이용해서 재고를 한번에 수정할 수 있다!!!
UPDATE products P
JOIN 	 orderdetail OD ON P.pno = OD.pno
SET 	 P.stock = P.stock - OD.qty
WHERE  OD.orderno = 3 ;

SELECT *
FROM products;

SELECT *
FROM orders;

-- Q10) 전체 주문 목록을 출력하는 문장을 작성
SELECT V1.ORDERDATE, V1.CNAME,V1.ADDRESS,V1.PHONE, V1.`STATUS`, V2.PNAME,V2.COST,V2.QTY, V2.COST*V2.QTY AS `cost*qty`
FROM 
(SELECT C.CNO,C.CNAME, C.ADDRESS,C.PHONE,O.ORDERDATE,O.`STATUS`,O.ORDERNO FROM customers C JOIN orders O ON(C.CNO=O.CNO))V1
JOIN 
(SELECT P.PNAME,P.PNO,OD.QTY,OD.COST,OD.ORDERNO FROM products P JOIN orderdetail OD ON(P.PNO=OD.PNO))V2
ON (V1.ORDERNO=V2.ORDERNO);

-- 다른 분 코드 (그냥 간단히 다 조인해서 가져오기)
SELECT o.orderdate, c.cname, o.address, o.phone, o.STATUS, p.pname, d.cost, d.qty, d.cost*d.qty AS 'cost*qty'
FROM orders o
JOIN orderdetail d ON(o.orderno = d.orderno)
JOIN products p ON(d.pno = p.pno)
JOIN customers c ON(o.cno = c.cno);


-- Q11) 일별 매출 목록
SELECT ORDERDATE, SUM(COST*QTY)
FROM orderdetail OD JOIN orders O ON (OD.ORDERNO=O.ORDERNO)
GROUP BY O.ORDERDATE;

-- Q12) 신규 상품 정보를 products 테이블에 입력하시오.
-- “제품번호는 1007, 상품명은 목캔디, 단가는 3000원, 재고는 500개이다.”

INSERT INTO products 
VALUES('1007','목캔디',3000,500);

SELECT *
FROM products;

-- Q13) 4번 주문 정보를 입력하고, 재고를 적절히 수정하시오
-- 최진국(103)이 오늘 목캔디(1007)를 개당 3000원에 200개 주문하였으며, 
-- 배송지의 주소는 제주 동광양이며, 연락처는 352-4657이고, 결제가 완료된 상태이다.
-- 주문 등록

INSERT INTO ORDERS
VALUES
	(4, SYSDATE(),'제주 동광양','352-4657','결제완료',
																	(SELECT C.CNO FROM customers C WHERE C.CNAME='최진국'	)
	);
	
INSERT INTO orderdetail
VALUES
(4,(SELECT PNO FROM PRODUCTS WHERE PNAME= '목캔디'),200,3000);

-- 10번 문제 코들 다시 실행하면 최진국 확인 가능(오늘날짜로)