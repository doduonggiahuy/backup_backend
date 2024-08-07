from flask import Flask, request, jsonify, render_template, redirect, abort
from flask_restful import Api

app = Flask(__name__)
api = Api(app)

# Define your routes here
@app.route('/')
def home():
    return "Welcome to the Home Page"

@app.route('/login', methods=['POST'])
def login():
    # Login logic here
    pass
