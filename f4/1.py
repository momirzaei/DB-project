import random
with open('insert.sql', 'w') as f:
    for i in range(1, 21):
        id = str(i)
        name = 'Kindergarten_' + str(i)
        city = 'city_' + str(i % 5)
        address = 'address_' + id
        floor_count = random.randint(4, 10)
        query = f"BEGIN TRY INSERT INTO Kindergarten (id,name,city,address,floor_count) VALUES ({id},'{name}','{city}','{address}',{floor_count});END TRY BEGIN CATCH END CATCH"
        f.write(query)
        f.write('\n')

    for i in range(1, 1601):
        KG_id = str(i % 20 + 1)
        id = str(i)
        SSN = random.randint(1111111111, 9999999999)
        first_name = 'first_' + str(i)
        last_name = 'last_' + str(i)
        birthdate = str(random.randint(2016, 2021)) + '-' + \
            str(i % 12 + 1) + '-' + str(i % 30 + 1)
        fathers_name = 'fathers_' + str(i % 100 + 1)
        gender = 'M' if i % 2 else 'F'
        nutrition = 'nutrition_' + str(i)
        cost = random.randint(5000, 9000)
        query = f"BEGIN TRY INSERT INTO Child (KG_id,id,SSN,first_name,last_name,birthdate,fathers_name,gender,nutrition,cost) VALUES ({KG_id},{id},'{SSN}','{first_name}','{last_name}','{birthdate}','{fathers_name}','{gender}','{nutrition}',{cost});END TRY BEGIN CATCH END CATCH"
        f.write(query)
        f.write('\n')

    for i in range(1, 801):
        for j in range(5):
            child_id = random.randint(1, 1601)
            disease = 'disease_' + str(i)
            query = f"BEGIN TRY INSERT INTO Disease (child_id,disease) VALUES ({child_id},'{disease}');END TRY BEGIN CATCH END CATCH"
            f.write(query)
            f.write('\n')

    for i in range(1, 101):
        KG_id = str(i % 20 + 1)
        id = str(i)
        name = 'class_' + str(i)
        time = str(random.randint(8, 20)) + ":" + str(i % 60) + ":00"
        CFloor = random.randint(1, 4)
        term_start_date = '2022' + '-' + \
            str(i % 12 + 1) + '-' + str(i % 30 + 1)
        query = f"BEGIN TRY INSERT INTO Class (KG_id,id,name,time,CFloor,term_start_date) VALUES ({KG_id},{id},'{name}','{time}',{CFloor},'{term_start_date}');END TRY BEGIN CATCH END CATCH"
        f.write(query)
        f.write('\n')

    for i in range(1, 1601):
        for j in range(4):
            child_id = i
            class_id = str(random.randint(1, 101))
            score = i % 21
            query = f"BEGIN TRY INSERT INTO Participate (child_id,class_id,score) VALUES ({child_id},{class_id},{score});END TRY BEGIN CATCH END CATCH"
            f.write(query)
            f.write('\n')

    Speciality = ['M', 'P', 'C', 'B', 'F', 'E', 'A', 'R']
    for i in range(1, 101):
        id = str(i)
        SSN = random.randint(1111111111, 9999999999)
        first_name = 'first_' + str(i)
        last_name = 'last_' + str(i)
        birthdate = str(random.randint(1950, 1995)) + '-' + \
            str(i % 12 + 1) + '-' + str(i % 30 + 1)
        fathers_name = 'fathers_' + str(i)
        gender = 'M' if i % 2 else 'F'
        speciality = Speciality[i % 8]
        income = random.randint(5000, 9000)
        query = f"BEGIN TRY INSERT INTO Teacher (id,SSN,first_name,last_name,birthdate,fathers_name,gender,speciality,income) VALUES ({id},'{SSN}','{first_name}','{last_name}','{birthdate}','{fathers_name}','{gender}','{speciality}',{income});END TRY BEGIN CATCH END CATCH"
        f.write(query)
        f.write('\n')

    for i in range(1, 101):
        teacher_id = i
        for j in range(4):
            KG_id = str(random.randint(1, 21))
            query = f"BEGIN TRY INSERT INTO KGTeacher (teacher_id,KG_id) VALUES ({teacher_id},{KG_id});END TRY BEGIN CATCH END CATCH"
            f.write(query)
            f.write('\n')

    for i in range(1, 101):
        teacher_id = i
        for j in range(8):
            class_id = random.randint(1, 101)
            parent_score = i % 10 + 10
            query = f"BEGIN TRY INSERT INTO Teach (teacher_id,class_id,parent_score) VALUES ({teacher_id},{class_id},{parent_score});END TRY BEGIN CATCH END CATCH"
            f.write(query)
            f.write('\n')

    for i in range(1, 401):
        id = i
        name = 'tool_' + str(i)
        cost = random.randint(5000, 9000)
        application = 'application_' + str(i)
        total_count = random.randint(250, 500)
        query = f"BEGIN TRY INSERT INTO Tool (id,name,cost,application,total_count) VALUES ({id},'{name}',{cost},'{application}',{total_count});END TRY BEGIN CATCH END CATCH"
        f.write(query)
        f.write('\n')

    for i in range(1, 101):
        class_id = i
        for j in range(random.randint(3, 8)):
            tool_id = random.randint(1, 401)
            tool_count = random.randint(1, 8)
            query = f"BEGIN TRY INSERT INTO Class_Tool (class_id,tool_id,tool_count) VALUES ({class_id},{tool_id},{tool_count});END TRY BEGIN CATCH END CATCH"
            f.write(query)
            f.write('\n')
