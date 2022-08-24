use master

Drop database Project
create database project

use project

CREATE TABLE Kindergarten (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    floor_count INTEGER NOT NULL
);

CREATE TABLE Child (
    KG_id INTEGER NOT NULL,
    id INTEGER PRIMARY KEY,
    SSN CHAR(10) UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birthdate DATE NOT NULL,
    fathers_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    nutrition VARCHAR(255),
    cost INTEGER NOT NULL,
    CONSTRAINT cost CHECK (cost > 1000),    
    FOREIGN KEY (KG_id) REFERENCES Kindergarten(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Disease (
    child_id INTEGER,
    disease VARCHAR(255) NOT NULL,
    PRIMARY KEY (child_id,disease),
    FOREIGN KEY (child_id) REFERENCES Child (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Class (
    KG_id INTEGER NOT NULL,
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    time TIME NOT NULL,
    CFloor INTEGER NOT NULL,
    term_start_date DATE NOT NULL,
    FOREIGN KEY (KG_id) REFERENCES Kindergarten(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Participate (
    child_id INTEGER,
    class_id INTEGER,
    score INTEGER,
    CHECK(score BETWEEN 0 AND 20),
    PRIMARY KEY (child_id,class_id),
    FOREIGN KEY (child_id) REFERENCES Child (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (class_id) REFERENCES Class (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Teacher (
    id INTEGER PRIMARY KEY,
    SSN CHAR(10) UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birthdate DATE NOT NULL,
    fathers_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    speciality CHAR(1) NOT NULL, 
    income INTEGER NOT NULL,
    CONSTRAINT teacher_birth_date CHECK (DATEDIFF(YEAR, birthdate, GETDATE()) > 25)
);

CREATE TABLE KGTeacher (
    teacher_id INTEGER,
    KG_id INTEGER,
    PRIMARY KEY (KG_id,teacher_id),
    FOREIGN KEY (KG_id) REFERENCES Kindergarten(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Teach (
    teacher_id INTEGER,
    class_id INTEGER,
    parent_score INTEGER,
    CHECK(parent_score BETWEEN 10 AND 20),
    PRIMARY KEY (class_id,teacher_id),
    FOREIGN KEY (class_id) REFERENCES Class (id) ON DELETE CASCADE ON UPDATE CASCADE,  
    FOREIGN KEY (teacher_id) REFERENCES Teacher (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Tool (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cost INTEGER NOT NULL,
    application VARCHAR(255),
    total_count INTEGER NOT NULL
);

CREATE TABLE Class_Tool (
    class_id INTEGER,
    tool_id INTEGER,
    tool_count INTEGER NOT NULL,
    PRIMARY KEY (class_id,tool_id),
    FOREIGN KEY (class_id) REFERENCES Class (id) ON DELETE CASCADE ON UPDATE CASCADE,  
    FOREIGN KEY (tool_id) REFERENCES Tool (id) ON DELETE CASCADE ON UPDATE CASCADE
);


-----------------------------------------------------------
-- Child
ALTER TABLE Child ADD CONSTRAINT child_gender CHECK (gender='M' OR gender='F');
ALTER TABLE Child ADD CONSTRAINT child_SSN CHECK (SSN NOT LIKE '%[^0-9]%' AND LEN(SSN) = 10);
ALTER TABLE Child ADD CONSTRAINT child_birthdate CHECK (DATEDIFF(YEAR, birthdate, GETDATE()) < 7 AND DATEDIFF(YEAR, birthdate, GETDATE()) >= 1);
ALTER TABLE Child DROP CONSTRAINT cost;
ALTER TABLE Child ADD CONSTRAINT cost CHECK (cost > 2000);

-- Teacher
ALTER TABLE Teacher ADD CONSTRAINT teacher_gender CHECK (gender='M' OR gender='F');
ALTER TABLE Teacher ADD CONSTRAINT teacher_SSN CHECK (SSN NOT LIKE '%[^0-9]%' AND LEN(SSN) = 10);
ALTER TABLE Teacher ADD CONSTRAINT speciality CHECK (speciality='M' OR
                                                    speciality='P' OR 
                                                    speciality='C' OR 
                                                    speciality='B' OR 
                                                    speciality='F' OR 
                                                    speciality='E' OR 
                                                    speciality='A' OR 
                                                    speciality='R');
ALTER TABLE Teacher DROP CONSTRAINT teacher_birth_date;
ALTER TABLE Teacher ADD CONSTRAINT teacher_birth_date CHECK (DATEDIFF(YEAR, birthdate, GETDATE()) > 30);


-----------------------------------------------------------
-- طبقه ی کلاسی که اضافه می شود از طبقات مهدکودکش کمتر باشد
GO
CREATE OR ALTER TRIGGER InsertClass
ON Class
INSTEAD OF INSERT 
AS 
BEGIN
SET NOCOUNT ON
    DECLARE @KG_floor INTEGER
    DECLARE @C_floor INTEGER
    SELECT @KG_floor = floor_count FROM Kindergarten K JOIN INSERTED I ON K.id = I.KG_id
    SELECT @C_floor = CFloor FROM INSERTED I
    IF @C_floor < @KG_floor 
    BEGIN
        INSERT INTO Class(KG_id,id,name,time,CFloor,term_start_date)
        SELECT I.KG_id,I.id,I.name,I.time,I.CFloor,I.term_start_date FROM INSERTED I
    END
	ELSE
	BEGIN
		PRINT 'cant insert this class because of constraint in Floor count!'
	END
END

-- INSERT INTO Class (KG_id,id,name,time,CFloor,term_start_date) VALUES (2,987,'class_1','17:1:00',11,'2022-2-2');
-- SELECT * FROM Class WHERE id = 987


----------------
-- هنگام اضافه شدن ابزاری به کلاس بررسی شود که مجموع ابزار های در حال استفاده از مجموع ابزار های موجود در مخزن تجاوز نکند 
GO
CREATE OR ALTER TRIGGER AddTool
ON Class_Tool
INSTEAD OF INSERT 
AS 
BEGIN
SET NOCOUNT ON
    DECLARE @total_count INTEGER
    DECLARE @total_count_in_use INTEGER
    DECLARE @insertedcount INTEGER
    DECLARE @check_exist INTEGER
    SELECT @total_count = total_count FROM Tool T JOIN INSERTED I ON T.id = I.tool_id
    SELECT @check_exist = COUNT(*) FROM Class_Tool CT JOIN INSERTED I ON CT.tool_id = I.tool_id
    SELECT @insertedcount = tool_count FROM INSERTED I

    IF @check_exist = 0
    BEGIN
        IF @insertedcount <= @total_count
        BEGIN
            INSERT INTO Class_Tool(class_id,tool_id,tool_count)
            SELECT I.class_id,I.tool_id,I.tool_count FROM INSERTED I
        END
		ELSE
		BEGIN
			PRINT 'cant insert this class because of constraint in Tool count!'
		END
    END
    ELSE
    BEGIN
        SELECT @total_count_in_use = SUM(CT.tool_count) FROM Class_Tool CT JOIN INSERTED I ON CT.tool_id = I.tool_id
        IF @total_count_in_use + @insertedcount <= @total_count
        BEGIN
            INSERT INTO Class_Tool(class_id,tool_id,tool_count)
            SELECT I.class_id,I.tool_id,I.tool_count FROM INSERTED I
        END
		ELSE
		BEGIN
			PRINT 'cant insert this class because of constraint in Tool count!'
		END
    END
END

-- INSERT INTO Class_Tool (class_id,tool_id,tool_count) VALUES (1,128,1000);
-- SELECT * FROM Class_Tool WHERE tool_id = 128

----------------
-- هنگام اضافه شدن یک کودک به کلاس، بررسی شود که کودک و کلاس هر دو متعلق به یک مهد کودک باشند
GO
CREATE OR ALTER TRIGGER AddChildToClass
ON Participate
INSTEAD OF INSERT 
AS 
BEGIN
SET NOCOUNT ON
    DECLARE @child_KG INTEGER
    DECLARE @class_KG INTEGER
    SELECT @child_KG = KG_id FROM Child C JOIN INSERTED I ON C.id = I.child_id
    SELECT @class_KG = KG_id FROM Class C JOIN INSERTED I ON C.id = I.class_id

    IF @child_KG = @class_KG
    BEGIN
        INSERT INTO Participate(child_id,class_id,score)
        SELECT I.child_id,I.class_id,I.score FROM INSERTED I
    END
	ELSE
	BEGIN
		PRINT 'cant insert this class because of constraint in matching KG!'
	END
END

-- DELETE FROM Participate WHERE child_id = 1 AND class_id = 21
-- INSERT INTO Participate (child_id,class_id,score) VALUES (1,21,13);
-- SELECT * FROM Participate WHERE class_id = 21

-- INSERT INTO Participate (child_id,class_id,score) VALUES (1,7,1);
-- SELECT * FROM Participate WHERE class_id = 7

----------------
-- هنگام اضافه شدن یک معلم به کلاس، بررسی شود که معلم در مهدکودک متعلق به کلاس عضو باشد
GO
CREATE OR ALTER TRIGGER AddTeacherToClass
ON Teach
INSTEAD OF INSERT 
AS 
BEGIN
SET NOCOUNT ON
    DECLARE @class_KG INTEGER
    DECLARE @Teacher_KG INTEGER
    SELECT @class_KG = KG_id FROM Class C JOIN INSERTED I ON C.id = I.class_id
    SELECT @Teacher_KG = COUNT(*) FROM KGTeacher K JOIN INSERTED I ON K.teacher_id = I.teacher_id WHERE K.KG_id = @class_KG

    IF @Teacher_KG != 0
    BEGIN
        INSERT INTO Teach(teacher_id,class_id,parent_score)
        SELECT I.teacher_id,I.class_id,I.parent_score FROM INSERTED I
    END
	ELSE
	BEGIN
		PRINT 'cant insert this class because of constraint in matching KG!'
	END
END

-- DELETE FROM Teach WHERE teacher_id = 92 AND class_id = 37
-- INSERT INTO Teach (teacher_id,class_id,parent_score) VALUES (92,37,11);
-- SELECT * FROM Teach WHERE class_id = 37

-- INSERT INTO Teach (teacher_id,class_id,parent_score) VALUES (1,21,11);
-- SELECT * FROM Teach WHERE class_id = 1
----------------