import requests
import json
import time
import psycopg2
import flask
import random
import secrets
from flask import Flask, request, jsonify, render_template, redirect, abort
from flask_restful import Resource, Api
from json import dumps
from datetime import datetime, timedelta, timezone
from gevent.pywsgi import WSGIServer

app = Flask(__name__)
api = Api(app)

def createCurrentDate():
    now = datetime.now()
    tz = timezone(timedelta(hours=7))
    new_time = now.astimezone(tz)
    
    print("now =", new_time)

    # dd/mm/YY H:M:S
    dt_string = new_time.strftime("%d/%m/%Y %H:%M:%S")
    print("date and time =", dt_string)
    return dt_string

#Check already login
def checkAccessToken(user_id, access_token):
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()

        postgresSQL_select_Query = """ SELECT access_token FROM userdata WHERE user_id = '{}' """.format(user_id)
        cursor.execute(postgresSQL_select_Query)
        
        result = cursor.fetchall()
        
        for row in result:
            result = row[0]

        connection.commit()
        count = cursor.rowcount

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return False

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    
    if result == access_token:
        return True
    else:
        return False

# CHECK LOGIN STATUS
def checkLoginStatus(email, user_password):
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()

        postgresSQL_select_Query = """ SELECT count(1) > 0 FROM userdata WHERE email = '{}' AND user_password = '{}' """.format(email, user_password)
        cursor.execute(postgresSQL_select_Query)
        
        result = cursor.fetchall()
        
        for row in result:
            result = row[0]

        connection.commit()
        count = cursor.rowcount

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return False

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    
    if result:
        return True
    else:
        return False

# CHECK USER_NAME EXIST
def checkUserNameExist(email):
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()

        postgresSQL_select_Query = """ SELECT count(1) > 0 FROM userdata WHERE email = '{}' """.format(email)
        cursor.execute(postgresSQL_select_Query)
        
        result = cursor.fetchall()
        
        for row in result:
            result = row[0]

        connection.commit()
        count = cursor.rowcount

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return False

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    print(result)
    if result:
        return True
    else:
        return False
    
# API SIGN UP
@app.route('/signup', methods = ['POST'])
def signup():
    email = request.form.get('email')
    user_password = request.form.get('user_password')
    print(email)
    if not email:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not user_password:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if checkUserNameExist(email):
        return {"error": "Username already exists"}, 409
    else:
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')
            
            cursor = connection.cursor()
            
            postgress_insert_query = """ INSERT INTO userdata (email, user_password, is_premium) VALUES (%s,%s,%s)"""
            record_to_insert = (email, user_password, '0')
            cursor.execute(postgress_insert_query, record_to_insert)

            connection.commit()
            count = cursor.rowcount
            print(count, "Record inserted successfully into data table")

        except (Exception, psycopg2.Error) as error:
            print("Failed to insert record into data table", error)

        finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
        return {"result": "Sign Up successful!"}, 200
    
# API LOGIN
@app.route('/login', methods = ['POST'])
def login():
    email = request.form.get('email')
    user_password = request.form.get('user_password')
    access_token = secrets.token_hex(20)
    time.sleep(3)
    print(access_token)
    if not email:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not user_password:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if checkLoginStatus(email, user_password):
        profileData = {}
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')
            
            cursor = connection.cursor()
            
            postgress_insert_query = """ UPDATE userdata SET access_token = %s WHERE email = %s"""
            record_to_insert = (access_token, email)
            cursor.execute(postgress_insert_query, record_to_insert)

            connection.commit()
            count = cursor.rowcount
            print(count, "Record inserted successfully into data table")

        except (Exception, psycopg2.Error) as error:
            print("Failed to update record into data table", error)

        finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
        
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')
            
            cursor = connection.cursor()

            postgresSQL_select_Query = """ SELECT user_id, user_name, birthday, email, is_premium, role, access_token FROM userdata WHERE email = '{}' """.format(email)
            cursor.execute(postgresSQL_select_Query)
            
            result = cursor.fetchall()
            
            for row in result:
                print(row)
                profileUser = {
                    "user_id": row[0],
                    "user_name": row[1],
                    "birthday": row[2],
                    "email": row[3],
                    "is_premium": row[4],
                    "role": row[5],
                    "access_token": row[6]
                    }

            connection.commit()
            count = cursor.rowcount

        except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

        finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
        return {"result": "Login is Successful!", 
                "profile_user": profileUser}, 200
    else:
        return {"error": "Login is Failed!"}, 401

# API GET USER INFO
@app.route('/get-user-info', methods = ['GET'])
def getUserInfo(id):
    user_id = flask.request.headers.get('user-id')
    if id:
        user_id = id
    # access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    # if not access_token:
    #     return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    # if checkAccessToken(user_id, access_token):
    profileUser = {}
    try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

            cursor = connection.cursor()

            postgresSQL_select_Query = """ SELECT user_id, user_name, birthday, email, is_premium, role FROM userdata WHERE user_id = '{}' """.format(user_id)
            cursor.execute(postgresSQL_select_Query)
            
            result = cursor.fetchall()
            
            for row in result:
                profileUser = {
                    "user_id": row[0],
                    "user_name": row[1],
                    "birthday": row[2],
                    "email": row[3],
                    "is_premium": row[4],
                    "role": row[5]
                    }

            connection.commit()
            count = cursor.rowcount

    except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

    finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
        
    return {"result": profileUser}
    # else:
    #     return {"error": "Access token is expired!"}, 401

# API GET HOME DATA
# @app.route('/get-home-data', methods = ['GET'])
# def getHomeData():
#     countryData = []
#     try:
#         connection = psycopg2.connect(user="postgres",
#                             password="family",
#                             host="localhost",
#                             port="5432",
#                             database='todolist')

#         cursor = connection.cursor()

#         postgresSQL_select_Query = """ SELECT country_id, country_name FROM country """
#         cursor.execute(postgresSQL_select_Query)
        
#         result = cursor.fetchall()
        
#         for row in result:
#             country = {
#                 "country_id": row[0],
#                 "country_name": row[1]
#                 }
#             countryData.append(country)

#         connection.commit()
#         count = cursor.rowcount

#     except (Exception, psycopg2.Error) as error:
#         print("Failed to Get record data table", error)
#         return {"error": "Failed to get information."}, 400

#     finally:
#         # closing database connection.
#         if connection:
#             cursor.close()
#             connection.close()
#             print("PostgreSQL connection is closed")
            
#     radioData = []
#     try:
#         connection = psycopg2.connect(user="postgres",
#                             password="family",
#                             host="localhost",
#                             port="5432",
#                             database='todolist')

#         cursor = connection.cursor()

#         postgresSQL_select_Query = """ SELECT radio_id, url_link, image_link, genre_id, country_id, radio_name, listen_count, share_count, type_id FROM radio ORDER BY RANDOM()
# LIMIT 10;"""
#         cursor.execute(postgresSQL_select_Query)
        
#         result = cursor.fetchall()
        
#         for row in result:
#             radio = {
#                 "radio_id": row[0],
#                 "url_link": row[1],
#                 "image_link": row[2],
#                 "genre": getGenreName(row[3]),
#                 "country": getCountryData(row[4]),
#                 "radio_name": row[5],
#                 "listen_count": row[6],
#                 "share_count": row[7],
#                 "type_id": row[8]
#                 }
#             radioData.append(radio)

#         connection.commit()
#         count = cursor.rowcount

#     except (Exception, psycopg2.Error) as error:
#         print("Failed to Get record data table", error)
#         return {"error": "Failed to get information."}, 400

#     finally:
#         # closing database connection.
#         if connection:
#             cursor.close()
#             connection.close()
#             print("PostgreSQL connection is closed")
    
#     return {"country": countryData,
#             "radio_list": radioData}

# API GET TASK
@app.route('/get-task-list', methods = ['GET'])
def getTasks():
    user_id = flask.request.headers.get('user-id')
    access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not access_token:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    tasks = []
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()

        postgresSQL_select_Query = """ SELECT * FROM task where user_id = '{}' OR '{}' = ANY(assignee_ids) """.format(user_id, user_id)
        cursor.execute(postgresSQL_select_Query)
        
        result = cursor.fetchall()
        print(result)
        for row in result:
            task = {
                "id": row[0],
                "title": row[1],
                "priority": row[2],
                "start_time": row[3],
                "end_time": row[4],
                "description": row[5],
                "assignee_ids": row[6],
                "status": row[8] if row[8] else 'Open',
                "group_id": row[9],
                "estimate_time": row[10] 
                }
            tasks.append(task)

        connection.commit()

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return {"error": "Failed to get information."}, 400

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    return {"tasks": tasks}

@app.route('/get-noti-list', methods = ['GET'])
def getNotiList():
    user_id = flask.request.headers.get('user-id')
    access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not access_token:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    tasks = []
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()
        postgresSQL_select_Query =  """SELECT * FROM task WHERE {} = ANY(assignee_ids)""".format(user_id)
        cursor.execute(postgresSQL_select_Query)
        
        result = cursor.fetchall()

        
        for row in result:
            user_info = getUserInfo(row[11])
            user_name = ''
            if user_info and 'result' in user_info and user_info['result']:
                user_name = user_info['result']['email']
                print(user_info['result'])
            task = {
                "id": row[0],
                "title": "{} assigned for you.".format(user_name),
                "task_title": row[1],
                "priority": row[2],
                "start_time": row[3],
                "end_time": row[4],
                "description": row[5],
                "assignee_ids": row[6],
                "status": row[8] if row[8] else 'Open',
                "group_id": row[9],
                "estimate_time": row[10],
                "creator_id": row[11],
                "is_read": int(user_id) in list(row[13]),
                "created_date": row[12],
                }
            tasks.append(task)

        connection.commit()

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return {"error": "Failed to get information."}, 400

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    return {"tasks": tasks}

# API SEARCH
@app.route('/search', methods = ['POST'])
def searchTask():
    user_id = flask.request.headers.get('user-id')
    access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid!1"}, 400, {'Content-Type': 'application/json'}
    if not access_token:
        return {"error": "Parameter is invalid!2"}, 400, {'Content-Type': 'application/json'}
    keyword = request.args.get('keyword')
    tasks = []
    queryString = """ """
    # print(genre_id)
    # print(country_id)
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()
        # if genre_id == 0 and country_id == 0:
        #     queryString = """ SELECT radio_id, url_link, image_link, genre_id, country_id, radio_name, listen_count, share_count, type_id FROM radio WHERE radio_name ILIKE '%{}%' """.format(keyword)
        # if genre_id == 0 and country_id != 0:
        #     queryString = """ SELECT radio_id, url_link, image_link, genre_id, country_id, radio_name, listen_count, share_count, type_id FROM radio WHERE radio_name ILIKE '%{}%' AND country_id = {} """.format(keyword, country_id)
        # if genre_id != 0 and country_id == 0:
        #     queryString = """ SELECT radio_id, url_link, image_link, genre_id, country_id, radio_name, listen_count, share_count, type_id FROM radio WHERE radio_name ILIKE '%{}%' AND genre_id = {} """.format(keyword, genre_id)        
        # if genre_id != 0 and country_id != 0:
        #     queryString = """ SELECT radio_id, url_link, image_link, genre_id, country_id, radio_name, listen_count, share_count, type_id FROM radio WHERE radio_name ILIKE '%{}%' AND genre_id = {} AND country_id = {} """.format(keyword, genre_id, country_id)
        
        queryString = """ SELECT id, title FROM task WHERE user_id = '{}' AND title ILIKE '%{}%'  """.format(user_id, keyword)
        postgresSQL_select_Query = queryString
        cursor.execute(postgresSQL_select_Query)
        
        result = cursor.fetchall()
        print(result)
        for row in result:
            task = {
                "id": row[0],
                "title": row[1],
                }
            tasks.append(task)
            

        connection.commit()

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return {"error": "Failed to get information."}, 400

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
            
    return {"tasks": tasks}



#API ADD TASK
@app.route('/add-task', methods = ['POST'])
def addTask():
    task_data = request.json
    user_id = int(task_data.get('user_id'))
    access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid"}, 400, {'Content-Type': 'application/json'}
    if not access_token:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    print(task_data)
    title = task_data.get('title')
    priority = task_data.get('priority')
    start_time = task_data.get('start_time')
    end_time = task_data.get('end_time')
    description = task_data.get('description')
    assignee_ids = task_data.get('assignee_ids')
    group_id = task_data.get('group_id')
    estimate_time = task_data.get('estimate_time')
    try:
        connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

        cursor = connection.cursor()
        postgress_insert_query = """ INSERT INTO task (user_id, title, priority, start_time, end_time, description, assignee_ids, group_id, estimate_time) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
        record_to_insert = (user_id, title, priority, start_time, end_time, description,  assignee_ids, group_id, estimate_time)
        cursor.execute(postgress_insert_query, record_to_insert)

        connection.commit()

    except (Exception, psycopg2.Error) as error:
        print("Failed to Get record data table", error)
        return {"error": "Failed to get information."}, 400

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    
    return {"result": "Add Task Success"}

#REMOVE TASK
@app.route('/remove-task', methods = ['POST'])
def removeTask():
    task_id = int(request.args.get('task_id'))
    user_id = flask.request.headers.get('user-id')
    access_token = flask.request.headers.get('x-access-token')
    if checkAccessToken(user_id, access_token):
        try:
            connection = psycopg2.connect(user="postgres",
                               password="family",
                               host="localhost",
                              port="5432",
                             database='todolist')
        
            cursor = connection.cursor()
        
            postgress_insert_query = """ DELETE FROM task WHERE id = {} AND user_id = {} """.format(task_id, user_id)
            cursor.execute(postgress_insert_query)

            connection.commit()
            count = cursor.rowcount
            print(count, "Record inserted successfully into data table")

        except (Exception, psycopg2.Error) as error:
            print("Failed to insert record into data table", error)

        finally:
        # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
        return {"result": "Remove task successful!"}, 200
    else:
        return {"error": "Access token is expired!"}, 401
    

 #Update TASK
@app.route('/update-task', methods = ['POST'])
def updateTask():
    title = request.args.get('title')
    priority = request.args.get('priority')
    start_time = request.args.get('start_time')
    status_id = request.args.get('status')
    description = request.args.get('description')
    assignee_ids_str = request.args.get('assignee_ids')
    estimate_time = request.args.get('estimate_time')
    task_id = int(request.args.get('task_id'))
    user_id = flask.request.headers.get('user-id')
    access_token = flask.request.headers.get('x-access-token')
    # assignee_ids = [int(id) for id in assignee_ids_str.split(',')]
    # comment_ids = [int(id) for id in comment_ids_str.split(',')]
    update_values = []
    if checkAccessToken(user_id, access_token):
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

            cursor = connection.cursor()
            as_str = ''

            if status_id is not None:
                status_id = """status = {}""".format(int(status_id))
                update_values.append(status_id)
            if title is not None:
                title = """title = '{}'""".format(title)
                update_values.append(title)
            if priority is not None:
                priority = """priority = {}""".format(int(priority))
                update_values.append(priority)
            if start_time is not None:
                start_time = """start_time = '{}'""".format(start_time)
                update_values.append(start_time)
            if description is not None:
                description = """description = '{}'""".format(description)
                update_values.append(description)
            if assignee_ids_str is not None:
                as_str =  assignee_ids_str
                assignee_ids_str = """assignee_ids = ARRAY[{}]::integer[]""".format(assignee_ids_str)
                update_values.append(assignee_ids_str)
            if estimate_time is not None:
                estimate_time = """estimate_time = {}""".format(float(estimate_time))
                update_values.append(estimate_time)
            str = ','.join(update_values)
            if as_str != '':
                as_str = "OR user_id IN ({})".format(as_str)
            postgres_update_query = """UPDATE task 
                          SET {}
                          WHERE id = {} AND ( user_id = {} {})""".format(str, task_id, user_id, as_str)
            print('XXX:', postgres_update_query)
            cursor.execute(postgres_update_query)

            connection.commit()

        except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

        finally:
        # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
    
        return {"result": "Update Task Success"}
    else:
        return {"error": "Access token is expired!"}, 401



#read noti
@app.route('/read-noti', methods = ['POST'])
def readNoti():
    task_id = int(request.args.get('task_id'))
    user_id = flask.request.headers.get('user-id')
    access_token = flask.request.headers.get('x-access-token')
    print("read-noti")
    if checkAccessToken(user_id, access_token):
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

            cursor = connection.cursor()
            postgres_update_query ="""UPDATE task 
                          SET read_ids = array_append(read_ids, {})
                          WHERE NOT {} = ANY(read_ids) AND id = {}""".format(user_id, user_id, task_id)
            cursor.execute(postgres_update_query)

            connection.commit()

        except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

        finally:
        # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
    
    return {"result": "Update Success"}
    # else:
    #     return {"error": "Access token is expired!"}, 401


@app.route('/get-list-user-by-workspace', methods = ['GET'])
def getUserInfoInWorkSpace():
    user_id = flask.request.headers.get('user-id')
    # workspace_id = int(request.args.get.get('workspace_id'))
    access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not access_token:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if checkAccessToken(user_id, access_token):
        users = []
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

            cursor = connection.cursor()

            postgresSQL_select_Query = """ SELECT user_id, user_name, email FROM userdata WHERE NOT user_id = {} """.format(user_id)
            cursor.execute(postgresSQL_select_Query)
            
            result = cursor.fetchall()
            
            for row in result:
                user = {
                    "user_id": row[0],
                    "user_name": row[1],
                    "email": row[2],
                    }
                users.append(user)
            connection.commit()
            count = cursor.rowcount

        except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

        finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
    else:
        return {"error": "Access token is expired!"}, 401   
    return {"result": users}

@app.route('/add-comment', methods = ['POST'])
def addComment():
    user_id = flask.request.headers.get('user-id')
    task_id = int(request.args.get('task_id'))
    content = request.args.get('content')
    access_token = flask.request.headers.get('x-access-token')
    if not user_id:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not access_token:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if checkAccessToken(user_id, access_token):
        try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

            cursor = connection.cursor()
            postgresSQL_select_Query = """ INSERT INTO comment (user_id, content, created_at, task_id) VALUES ({}, '{}', '{}', {}) RETURNING id;""".format(user_id, content, createCurrentDate(), task_id)
            cursor.execute(postgresSQL_select_Query)
            connection.commit()

        except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

        finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
    else:
        return {"error": "Access token is expired!"}, 401   
    return {"result": "Add comment successful!"}

@app.route('/get-list-comment', methods = ['GET'])
def getListCommment():
    # user_id = flask.request.headers.get('user-id')
    task_id = int(request.args.get('task_id'))
    # access_token = flask.request.headers.get('x-access-token')
    # if not user_id:
    #     return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    # if not access_token:
    #     return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    # if checkAccessToken(user_id, access_token):
    comments = []
    try:
            connection = psycopg2.connect(user="postgres",
                            password="admin",
                            host="localhost",
                            port="5432",
                            database='learnbe')

            cursor = connection.cursor()

            postgresSQL_select_Query = """ SELECT user_id, content, created_at FROM comment WHERE task_id = {} ORDER BY created_at DESC;""".format(task_id)
            cursor.execute(postgresSQL_select_Query)
            
            result = cursor.fetchall()
            print(result)
            if result:
                for row in result:
                    user = getUserInfo(row[0])
                    comment = {
                        "user": {"email": user['result']["email"], "user_name":  user['result']["user_name"]},
                        "content": row[1],
                        "created_at": row[2],
                        }
                    comments.append(comment)
            else:
                return {"result": []}
            connection.commit()
            count = cursor.rowcount

    except (Exception, psycopg2.Error) as error:
            print("Failed to Get record data table", error)
            return {"error": "Failed to get information."}, 400

    finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")
        
    return {"result": comments}



# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port='5003', debug= True, threaded=True)

if __name__ == '__main__':
    from waitress import serve
    # serve(app, host="192.168.110.251", port=8080)
    serve(app, host="127.0.0.0", port=8080, threads=25, connection_limit=1000)