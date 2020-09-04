import os
import json
import mysql.connector
from config import config
from flask import Flask, render_template, jsonify, redirect, request, session

app = Flask(__name__)

app.secret_key = os.urandom(10)

# BACKEND

db = mysql.connector.connect(
	host=config['host'],
	user=config['username'],
	password=config['password'],
	database=config['database'],
)

def get_user_id_from_username(username):
	cursor = db.cursor()
	query = f'SELECT User.id_utente FROM User WHERE User.Username="{username}"'
	cursor.execute(query)
	result = cursor.fetchone()[0]
	return result

def create_tell(tell_sender, tell_receiver, tell_answer):
	try:
		cursor = db.cursor()
		query = f'''INSERT INTO Tell (question, answer, id_utente_recv, id_utente_post)
					VALUES ("{tell_answer}", "", {tell_receiver}, {tell_sender})'''
		cursor.execute(query)
		db.commit()
		return 0
	except Exception as e:
		print(e)
		return -1
	return -1

@app.route('/api/tell/create', methods=['POST'])
def create():
	response = {}
	
	# Create a tellonym for a specified user
	# Must be a username
	tell_user_target = request.form['target_user']
	# The one who post the answer
	tell_user_poster = request.form['post_user']
	# The answer that is posted
	tell_answer = request.form['tell_answer']
	
	# Check correct variable format (security purposes)
	if type(tell_user_target) is str and type(tell_user_poster) is str and type(tell_answer) is str:
		tell_user_target_id = get_user_id_from_username(tell_user_target)
		tell_user_poster_id = get_user_id_from_username(tell_user_poster)
		status = create_tell(tell_user_poster_id, tell_user_target_id, tell_answer)
		if status == 0:
			response = {'status_code': 200, 'message': 'success'}
			# Spot the confirmation to the user
			return redirect(f'/user/{tell_user_target}')
		elif status == -1:
			response = {'status_code': 400, 'message': 'an error occurred'}
			# Spot the error to the user
			return redirect(f'/user/{tell_user_target}')
	
	return jsonify(response)

def check_login(username, password):
	cursor = db.cursor()
	query = f'SELECT User.id_utente FROM User WHERE User.Username="{username}" AND User.password="{password}"'
	cursor.execute(query)
	results = cursor.fetchone()
	if len(results) > 0:
		return 0
	else:
		return -1
	return -1

def get_username_from_id(user_id):
	cursor = db.cursor()
	query = f'SELECT User.Username FROM User WHERE User.id_utente={user_id}'
	cursor.execute(query)
	result = cursor.fetchone()[0]
	return result

def serialize_results(results):
	result = []
	
	for tell in results:
		result.append(
			{
				"question": tell[1],
				"answer": tell[2],
				"receiver": get_username_from_id(tell[3]),
				"sender": get_username_from_id(tell[4]),
			}
		)
	return result

@app.route('/api/login', methods=['POST'])
def login():
	username = request.form['username']
	password = request.form['password']
	login = check_login(username, password)
	if login == 0:
		response = {'status_code': 200, 'message': 'login success'}
		session['curr_user'] = username
		session['loggedin'] = True
		return redirect('/user/__vndefined') # To change in home or own profile
	elif login == -1:
		response = {'status_code': 400, 'message': 'login error'}
		return redirect('/')
	return jsonify(response)

def get_user_tells_from_id(user_id):
	cursor = db.cursor()
	query = f'SELECT * FROM Tell WHERE Tell.id_utente_recv={user_id} AND Tell.answered==NULL'
	cursor.execute(query)
	results = cursor.fetchall()
	serialized_tells = serialize_results(results)
	return serialized_tells

# Get all the unanswered tells of a single user
@app.route('/api/tell/<user_id>', methods=['POST'])
def get_user_tells(user_id):
	response = {}
	
	# You must pass user credentials to require other user's tells
	username = request.form['username']
	password = request.form['password']
	login = check_login(username, password)
	if login == 0:
		tells = get_user_tells_from_id(user_id)
		response = {'status_code': 200, 'response': tells}
	elif login == -1:
		response = {'status_code': 400, 'message': 'an error occurred'}
	
	return jsonify(response)

# END BACKEND

# FRONTEND

@app.route('/', methods=['GET'])
def home():
	return render_template('index.html')

def serialize_user(user_data):
	print(user_data)
	data = {
			"first_name": user_data[1],
			"last_name": user_data[2],
			"username": user_data[5],
			"user_pic": user_data[6],
			"status": user_data[7],
			"followers": user_data[8],
			"following": user_data[9],
			"tells": user_data[10],  
		}
	return data
		
def get_user_data_from_username(username):
	cursor = db.cursor()
	query = f'SELECT * FROM User WHERE Username="{username}"'
	cursor.execute(query)
	results = cursor.fetchone()
	return serialize_user(results)

def get_user_tells_from_username(username):
	tells = []
	cursor = db.cursor()
	user_id = get_user_id_from_username(username)
	query = f'SELECT Tell.question, Tell.answer, Tell.id_utente_post FROM Tell WHERE Tell.id_utente_recv={user_id}'
	cursor.execute(query)
	results = cursor.fetchall()
	print('sos')
	print(json.dumps(results))
	#print(results)
	for result in results:
		tells.append(
			{
				"question": result[0],
				"answer": result[1],
				"sender": get_username_from_id(result[2]),
			}
		)
	return tells

@app.route('/user/<username>', methods=['GET'])
def user_profile(username):
	user_data = {}
	user_data = get_user_data_from_username(username)
	user_data["tells_list"] = get_user_tells_from_username(username)
	print(user_data["tells_list"])
	return render_template('user.html', value=user_data)

# END FRONTEND

# Add main function execution
app.run('0.0.0.0',debug=True)
