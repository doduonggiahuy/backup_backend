from datetime import datetime, timedelta, timezone
import psycopg2

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
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    if result == access_token:
        return True
    else:
        return False

def checkLoginStatus(email, user_password):
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="admin",
                                      host="localhost",
                                      port="5432",
                                      database='learnbe')
        cursor = connection.cursor()
        postgresSQL_select_Query = """ SELECT user_password FROM userdata WHERE email = '{}' """.format(email)
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
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

    if result == user_password:
        return True
    else:
        return False

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
    


def createCurrentDate():
    now = datetime.now()
    tz = timezone(timedelta(hours=7))
    new_time = now.astimezone(tz)
    
    print("now =", new_time)

    # dd/mm/YY H:M:S
    dt_string = new_time.strftime("%d/%m/%Y %H:%M:%S")
    print("date and time =", dt_string)
    return dt_string