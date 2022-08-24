-- نام و نام خانوادگی کودکانی که نام پدرشان فلان هست را بیابید

SELECT first_name,last_name 
FROM Child
WHERE fathers_name = 'fathers_23' 

---------------------
-- آیدی و مهد کودک های معلمانی که ریاضیات یاد میدهند را بیابید

SELECT T.id,K.name
FROM Teacher T JOIN KGTeacher KT ON T.id = KT.Teacher_id JOIN Kindergarten K ON KT.KG_id = K.id
WHERE T.speciality = 'M'
ORDER BY T.id

---------------------
-- آدرس و نام مهدکودک هایی که در شهر فلان قرار دارد را بیابید

SELECT name,address
FROM Kindergarten
WHERE city = 'city_2'

---------------------
-- مجموع قیمت ابزار هایی که در کلاس های مهد کودک فلان استفاده میشه

SELECT C.id,C.name,SUM(CT.tool_count * T.cost)
FROM Kindergarten K JOIN Class C ON K.id = C.KG_id JOIN Class_Tool CT ON C.id = CT.class_id JOIN Tool T ON CT.tool_id = T.id
WHERE K.id = 4
GROUP BY C.id,C.name
ORDER BY C.id

---------------------
-- نام کلاس هایی که در طبقه سوم مهدکودک ها برگزار میشود را نشان دهید

SELECT K.name,C.name
FROM Class C JOIN Kindergarten K ON C.KG_id = K.id
WHERE C.CFloor = 3
ORDER BY K.name

---------------------
-- آیدی کودکانی که در کلاس ریاضی ثبت نام کردند

SELECT P.child_id,C.name class
FROM Class C JOIN Teach T ON C.id = T.class_id JOIN Participate P ON C.id = P.class_id JOIN Teacher Tr ON Tr.id = T.teacher_id
WHERE Tr.speciality = 'M'
ORDER BY Tr.id

---------------------
-- نام نام خانوادگی و حقوق معلمانی که بین ساعت ۱۱ تا ۱۲ در کلاسی تدریس میکنند

SELECT Tr.first_name,Tr.last_name,Tr.income,C.name,C.time
FROM Teacher Tr JOIN Teach T ON Tr.id = T.teacher_id JOIN Class C ON C.id = T.class_id
WHERE C.time BETWEEN '11:00:00' AND '12:00:00'
ORDER BY Tr.first_name

---------------------
-- معلمانی که در کلاس خود بیش از 2 کودک دارند

SELECT Tr.first_name,Tr.last_name,C.name class_name,COUNT(P.child_id) child_count
FROM Class C JOIN Teach T ON C.id = T.class_id JOIN Participate P ON C.id = P.class_id JOIN Teacher Tr ON Tr.id = T.teacher_id
GROUP BY Tr.first_name,Tr.last_name,C.name
HAVING COUNT(P.child_id) > 2

---------------------
-- نام کلاس و تایم کلاس کودکانی که همه آن ها نمره بالای ۱۶ دارند

SELECT P.child_id,P.score,C.name,C.time
FROM Class C JOIN Participate P ON C.id = P.class_id
WHERE P.score > 16

---------------------
-- نام و نام خانوادگی معلمانی که در کلاس خود از فلان ابزار استفاده میکنند

SELECT Tr.first_name,Tr.last_name,C.name
FROM Teacher Tr JOIN Teach T ON Tr.id = T.teacher_id JOIN Class C ON C.id = T.class_id JOIN Class_Tool CT ON CT.class_id = C.id
WHERE CT.tool_id = 112

---------------------
-- نام و آیدی  کودکان پسری که بیماری فلان دارند را پیدا کنید

SELECT C.id,C.first_name,C.last_name
FROM Child C JOIN Disease D ON C.id = D.child_id
WHERE D.disease = 'Disease_34' AND C.gender = 'M'

---------------------
-- آیدی و نمره ریاضی کودکان از کم به زیاد مرتب کنید

SELECT P.child_id,P.score
FROM Class C JOIN Teach T ON C.id = T.class_id JOIN Participate P ON C.id = P.class_id JOIN Teacher Tr ON Tr.id = T.teacher_id
WHERE Tr.speciality = 'M'
ORDER BY P.score

---------------------
-- معدل کودکان مهدکودک فلان را حساب کنید

SELECT P.child_id,AVG(P.score)
FROM Child C JOIN Participate P ON C.id = P.child_id
WHERE C.KG_id = 3
GROUP BY P.child_id 

---------------------
-- آیدی و میانگین نمره معلمانی که نمره والدین به آن ها بیش تر از میانگین نمره والدین به کل معلم هاست

SELECT Tr.id,AVG(T.parent_score) avg_score
FROM Teacher Tr JOIN KGTeacher KGT ON Tr.id = KGT.teacher_id JOIN Teach T ON Tr.id = T.teacher_id
WHERE KGT.KG_id = 7
GROUP BY Tr.id
HAVING AVG(T.parent_score) > (SELECT AVG(T2.parent_score) 
                                FROM Teacher Tr2 JOIN KGTeacher KGT2 ON Tr2.id = KGT2.teacher_id JOIN Teach T2 ON Tr2.id = T2.teacher_id 
                                WHERE KGT2.KG_id = 7)

---------------------
-- نام و آیدی 5 کلاسی که ابزار موجود در آن بیشترین هزینه و قیمت را دارند پیدا کنید

SELECT TOP 5 C.id,C.name,SUM(CT.tool_count * T.cost) cost
FROM Kindergarten K JOIN Class C ON K.id = C.KG_id JOIN Class_Tool CT ON C.id = CT.class_id JOIN Tool T ON CT.tool_id = T.id
WHERE K.name = 'Kindergarten_4'
GROUP BY C.id,C.name
ORDER BY SUM(CT.tool_count * T.cost) DESC

---------------------
-- آیدی کودکانی که در طبقه دوم مهدکودک هایی در شهر فلان کلاسی دارند را بر اساس نام مهدکودک مرتب کنید

SELECT K.name Kname,C.name Cname,P.child_id
FROM Class C JOIN Kindergarten K ON C.KG_id = K.id JOIN Participate P ON P.class_id = C.id
WHERE C.CFloor = 2 AND K.city = 'city_1'
ORDER BY K.name

---------------------
-- نام معلمان ریاضی و مهدکودک های شان که در مهدکودکی در فلان شهر درس میدهند را بر اساس در آمد مرتب کنید

SELECT K.name,T.id,T.income
FROM Teacher T JOIN KGTeacher KT ON T.id = KT.Teacher_id JOIN Kindergarten K ON KT.KG_id = K.id
WHERE T.speciality = 'M' AND K.city = 'city_2'
ORDER BY T.income DESC

---------------------
-- لیست تغذیه کودکانی که نمره درس فلان از آن ها بالای 10 شده را بیابید

SELECT P.child_id,P.score
FROM Class C JOIN Teach T ON C.id = T.class_id JOIN Participate P ON C.id = P.class_id JOIN Teacher Tr ON Tr.id = T.teacher_id
WHERE Tr.speciality = 'M' AND P.score > 10
ORDER BY P.score