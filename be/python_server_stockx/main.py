import bcrypt
from flask import Flask, request, jsonify
from datetime import datetime, timedelta, timezone
import psycopg2
import jwt
import os

app = Flask(__name__)

# Secret key for JWT
SECRET_KEY = os.getenv('SECRET_KEY', 'your_very_secret_key_here')

# Function to create tokens
def create_tokens(email):
    now = datetime.now()
    access_token = jwt.encode({
        'email': email,
        'exp': now + timedelta(minutes=15)
    }, SECRET_KEY, algorithm='HS256')

    refresh_token = jwt.encode({
        'email': email,
        'exp': now + timedelta(days=7)
    }, SECRET_KEY, algorithm='HS256')

    return access_token, refresh_token

# utils-func
def createCurrentDate():
    now = datetime.now()
    tz = timezone(timedelta(hours=7))
    new_time = now.astimezone(tz)

    print("now =", new_time)

    # dd/mm/YY H:M:S
    dt_string = new_time.strftime("%d/%m/%Y %H:%M:%S")
    print("date and time =", dt_string)
    return dt_string

def check_email_exists(email):
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="admin",
                                      host="localhost",
                                      port="5432",
                                      database='stockx')

        cursor = connection.cursor()
        postgresSQL_select_Query = """SELECT count(1) > 0 FROM "user" WHERE email = %s"""
        cursor.execute(postgresSQL_select_Query, (email,))
        result = cursor.fetchone()[0]
    except (Exception, psycopg2.Error) as error:
        print("Failed to get record data table", error)
        return False
    finally:
        if connection:
            cursor.close()
            connection.close()
    return result
def check_username_exists(username):
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="admin",
                                      host="localhost",
                                      port="5432",
                                      database='stockx')

        cursor = connection.cursor()
        postgresSQL_select_Query = """SELECT count(1) > 0 FROM "user" WHERE username = %s"""
        cursor.execute(postgresSQL_select_Query, (username,))
        result = cursor.fetchone()[0]
    except (Exception, psycopg2.Error) as error:
        print("Failed to get record data table", error)
        return False
    finally:
        if connection:
            cursor.close()
            connection.close()
    return result

@app.route('/get-user/<user_id>')
def getUser(user_id):
    user_data = {
        "user_id": user_id,
        "user_name": "test",
        "email": "test@gmail.com"
    }

    extra = request.args.get('extra')
    if extra:
        user_data['extra'] = extra
    return jsonify(user_data), 200

@app.route('/create-user', methods=['POST'])
def createUser():
    data = request.get_json()
    return jsonify(data), 201

@app.route('/sign-up', methods=['POST'])
def signup():
    email = request.json.get('email')
    password_hash = request.json.get('password_hash')
    username = request.json.get('username')
    phone = request.json.get('phone')
    print(email)
    if not email:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if not password_hash:
        return {"error": "Parameter is invalid!"}, 400, {'Content-Type': 'application/json'}
    if check_email_exists(email):
        return {"error": "Email already exists"}, 409
    if check_username_exists(username):
        return {"error": "Username already exists"}, 409
    else:
        try:
            password_hash = bcrypt.hashpw(password_hash.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
            
            access_token, refresh_token = create_tokens(email)

            connection = psycopg2.connect(user="postgres",
                                          password="admin",
                                          host="localhost",
                                          port="5432",
                                          database='stockx')
            
            cursor = connection.cursor()
            
            postgres_insert_query = """INSERT INTO "user" (username, password_hash, email, full_name, phone_number, address, google_id, device_key, avatar_url, role_code, refresh_token) 
                                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
            record_to_insert = (username, password_hash, email, 'full_name', phone, 'address', 'google_id', 'device_key', 'avatar_url', 0, refresh_token)
            cursor.execute(postgres_insert_query, record_to_insert)

            connection.commit()
            count = cursor.rowcount
            print(count, "Record inserted successfully into user table")

        except (Exception, psycopg2.Error) as error:
            print("Failed to insert record into user table", error)
            return {"error": "Failed to insert record into user table"}, 500

        finally:
            # closing database connection.
            if connection:
                cursor.close()
                connection.close()
                print("PostgreSQL connection is closed")

        password_check = bcrypt.checkpw(password_hash.encode('utf-8'), password_hash.encode('utf-8'))

        return {
            "status": "successful!",
            "result": {
                "email": email,
                "access_token": access_token,
                "password_hash": password_hash,
                "password_check": password_check
            }
        }, 200

if __name__ == '__main__':
    app.run(debug=True)
