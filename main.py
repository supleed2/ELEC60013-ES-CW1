from config.variables import MAIL_SERVER, MAIL_PORT, MAIL_USERNAME, MAIL_PASSWORD, MAIL_USE_SSL, MAIL_USE_TLS
from flask import Flask
from firebase_admin import credentials, initialize_app
from api.authentication import authentication
from api.data import data

# Initialize Flask app and register all the endpoints
app = Flask(__name__)
app.register_blueprint(authentication)
app.register_blueprint(data)


# Initialize Mail instance
app.config['MAIL_SERVER'] = MAIL_SERVER
app.config['MAIL_PORT'] = MAIL_PORT
app.config['MAIL_USERNAME'] = MAIL_USERNAME
app.config['MAIL_PASSWORD'] = MAIL_PASSWORD
app.config['MAIL_USE_TLS'] = MAIL_USE_TLS
app.config['MAIL_USE_SSL'] = MAIL_USE_SSL

# Initialize Firebase
firebase = initialize_app(credentials.Certificate('firebase-key.json'))

@app.route('/')
def hello():
    return 'Hello World'

if __name__ == '__main__':
    app.run()
