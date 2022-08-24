--.پیدا کردن اطلاعات کودکانی که بیشتر از فلان قدر سال دارند
GO
CREATE OR ALTER PROCEDURE GET_AGE @AGE INTEGER AS
BEGIN
	SELECT DATEDIFF(YEAR, C.birthdate, GETDATE()) AGE ,C.fathers_name,C.last_name
	FROM Child C 
	WHERE DATEDIFF(YEAR, C.birthdate, GETDATE()) >= @AGE
	ORDER BY C.birthdate
END

EXEC GET_AGE @AGE = 5


--پیدا کردن کلاس های مهدکودک فلان که در فصل فلان شروع به کار میکند
GO
CREATE OR ALTER PROCEDURE  GET_CLASS @SEARCH_Kindergarten varchar(255) , @START_SEASON VARCHAR(20)   AS
BEGIN
	IF ( @START_SEASON = 'winter' )
	BEGIN
		SELECT C.*
		FROM CLASS C , Kindergarten K 
		WHERE K.name = @SEARCH_Kindergarten AND month(c.term_start_date) in (12, 1, 2) and c.KG_id=k.id
	END
		IF ( @START_SEASON = 'spring' )
	BEGIN
		SELECT C.*
		FROM CLASS C , Kindergarten K 
		WHERE K.name = @SEARCH_Kindergarten AND month(c.term_start_date) in (3, 4, 5) and c.KG_id=k.id
	END
		IF ( @START_SEASON = 'summer' )
	BEGIN
		SELECT C.*
		FROM CLASS C , Kindergarten K 
		WHERE K.name = @SEARCH_Kindergarten AND month(c.term_start_date) in (6, 7, 8) and c.KG_id=k.id
	END
		IF ( @START_SEASON = 'fall' )
	BEGIN
		SELECT C.*
		FROM CLASS C , Kindergarten K 
		WHERE K.name = @SEARCH_Kindergarten AND month(c.term_start_date) in (9, 10, 11) and c.KG_id=k.id
	END
END

EXEC GET_CLASS @SEARCH_Kindergarten = 'Kindergarten_6' , @START_SEASON = 'winter' 


--فانکشنی که ۲ سن مختلف را گرفته و میانگین نمرات افراد بین این ۲ سن را بر میگرداند
GO
CREATE OR ALTER FUNCTION GET_AVG_SCORE (@START INT , @FINISH INT) 
RETURNS TABLE 
AS
RETURN
	SELECT C.ID, C.birthdate, AVG(P.SCORE) AVG_SCORE
	FROM Child C , Participate P 
	WHERE P.child_id = C.ID AND DATEDIFF(YEAR, C.birthdate, GETDATE()) >= @START AND  DATEDIFF(YEAR, C.birthdate, GETDATE())<@FINISH
	GROUP BY C.ID, C.birthdate

GO
SELECT * FROM GET_AVG_SCORE(4,5) GAS


--فانکشنی که ۲ سن مختلف و یک محدوده کمینه برای میانگین گرفته و افراد بالای آن میانگین را بر میگرداند
GO
CREATE OR ALTER FUNCTION GET_AVG_SCORE_BETWEEN_AGE_UPER_THAN_X (@START_AGE INT , @FINISH_AGE INT ,@WANT INT ) 
RETURNS TABLE 
AS
RETURN
	SELECT * FROM GET_AVG_SCORE(@START_AGE,@FINISH_AGE) GAS
	WHERE GAS.AVG_SCORE > @WANT

GO
SELECT *  FROM GET_AVG_SCORE_BETWEEN_AGE_UPER_THAN_X(1,3,17) GASBAUTX 


--فانکشنی که با گرفتن آیدی مهدکودک میانگین حقوق افراد شاغل در آن را بر میگرداند
GO
CREATE or ALTER FUNCTION GET_AVG_INCOME(@KGID int)  
RETURNS float   
    AS 
    BEGIN       
        DECLARE @AVG_INCOME float = 0;     
        SELECT @AVG_INCOME =  AVG(T.income) FROM Kindergarten K , Teacher T , KGTeacher KGT
        WHERE K.id = @KGID AND K.id = KGT.KG_id AND KGT.teacher_id = T.id 
    
        RETURN @AVG_INCOME;
    END

GO
SELECT DBO.GET_AVG_INCOME(16)


--ویو از معلمانی که حقوقشان بیشتر از حقوق میانگین معلم ها است
GO
CREATE OR ALTER VIEW HIGHER_AVG AS
SELECT T.*
FROM Teacher T
WHERE income > (SELECT AVG(T1.income) FROM Teacher T1 )

GO
SELECT * FROM HIGHER_AVG


--ویو کلاس هایی که در فصل زمستان شروع به کار و بازه کاری آن ها بین ساعت ۸/۳۰ الی ۱۵/۳۰ می باشد
GO
CREATE OR ALTER VIEW CLASS_TIME AS
SELECT C.* 
FROM Class C
WHERE month(c.term_start_date) in (12, 1, 2) AND C.time BETWEEN '08:30:00' AND '19:30:00'

GO
SELECT * FROM CLASS_TIME
