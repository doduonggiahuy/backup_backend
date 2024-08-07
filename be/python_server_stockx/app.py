# from routes.main_routes import app
# from database.db_utils import checkAccessToken, checkLoginStatus, checkUserNameExist, createCurrentDate
# from auth.auth_utils import generate_access_token

# if __name__ == '__main__':
#     from waitress import serve
#     # serve(app, host="192.168.110.251", port=8080)
#     serve(app, host="127.0.0.0", port=8080, threads=25, connection_limit=1000)


import os
secret_key = os.urandom(24)
print(secret_key)