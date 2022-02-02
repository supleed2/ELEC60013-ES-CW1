from flask import Flask

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

app = Flask(__name__)

@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World! I am the dog you tracked with the amazing sensor from LEG industries...kidding this is just the home page :)'

if __name__ == '__main__':
    firebase_admin.initialize_app(credentials.Certificate('firebase-key.json'))
    app.run()
