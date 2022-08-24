ALTER TABLE Kindergarten
ADD KG_grade INTEGER NOT NULL default 3;

SELECT * FROM Kindergarten
ALTER TABLE Kindergarten ADD CONSTRAINT KG_grade CHECK (KG_grade > 1 AND KG_grade < 5);

ALTER TABLE Kindergarten
DROP COLUMN address 

DELETE FROM Participate WHERE child_id = (select c.id FROM Child c where last_name='last_27');
DELETE FROM Disease WHERE child_id =  (select c.id FROM Child c where last_name='last_27');
DELETE FROM Child WHERE last_name='last_27';

INSERT INTO Child (KG_id,id,SSN,first_name,last_name,birthdate,fathers_name,gender,nutrition,cost) VALUES (9,27,'6388794391','first_27','last_27','2020-5-29','fathers_27','F','nutrition_27',5172);
INSERT INTO Participate (child_id,class_id,score) VALUES (27,8,7);
INSERT INTO Participate (child_id,class_id,score) VALUES (27,28,7);
INSERT INTO Participate (child_id,class_id,score) VALUES (27,48,7);
INSERT INTO Participate (child_id,class_id,score) VALUES (27,68,7);

INSERT INTO Disease (child_id,disease) VALUES (27,'disease_38');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_78');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_219');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_458');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_471');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_486');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_602');
INSERT INTO Disease (child_id,disease) VALUES (27,'disease_711');

UPDATE Child
SET first_name = 'mamad', last_name= 'mamadi' ,cost = 15420000
WHERE id = 28;

UPDATE Child
SET first_name = 'first_28', last_name= 'last_28' ,cost = 15411000
WHERE id = 28;

select * FROM Child c ,Disease d where last_name='last_28' and c.id = d.child_id