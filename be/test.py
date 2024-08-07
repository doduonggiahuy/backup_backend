import os
secret_key = os.urandom(24)
print(secret_key)

# @app.route('/')
# def home():
#     return "Welcome to the StockX Server"

@app.route('/get-user/<user_id>')
def getUser(user_id):
    user_data ={
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
