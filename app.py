import json
from random import randint 
from flask import Flask, request
from flask_mail import Mail
from firebase_admin import credentials, firestore, auth

# Initialize Flask app
app = Flask(__name__)

# Initalize Mail instance
app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT'] = 465
#app.config['MAIL_USERNAME'] = ''
#app.config['MAIL_PASSWORD'] = ''
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True
mail = Mail(app)

# Initialize Firebase
firebase = firebase_admin.initialize_app(credentials.Certificate('firebase-key.json'))


@app.route('/')
def hello_world():
    return 'Hello World! I am the dog you tracked with the amazing sensor from LEG industries...kidding this is just the home page :)'

@app.route('/auth/register', methods=['POST']):
def register():
    email = request.form.get('email')
    password = request.form.get('email')
    name = request.form.get('name')
    deviceId = request.form.get('deviceid')
    
    # Some fields are not present
    if email is None or password is None or name is None or deviceId is None:
        return Response("{'error':'Entires missing'}", status=400, mimetype='application/json')

    # Register user with Firebase authentication
    user = auth.create_user(
        email=email
        email_verified=False,
        password=password,
        display_name=name,
        disabled=False)

    # Prompt the user to verify their email
    code = randint(100000, 999999)
    data = {
        u'code': code
    }
    firestore.client().collection(u'verification').document(user.uid).set(code)
    msg = Message('Please verify your email for BarkFinder', sender = 'TBA', recipients = [email])
    msg.body = '''Hey {}! Thank you for signing up for BarkFinder. 
                In order to use our sevices, could you please verify your email address by logging in and entering this code {}'''
                .format(name, code)
    mail.send(msg)

    # Link the user to the device
    data = {
        u'devices': [deviceId]
    }
    firestore.client().collection(u'devices').document(user.uid).set(data)
    
    # User succesfully created and linked to device
    resp = {"uid":user.uid}
    return Response(json.dumps(resp, 2), status=201, mimetype='application/json')


# An example of reading data from Firebase
# Taken from Firebase documentation
@app.route('/example/read', methods=['GET'])
def exampleRead():
    doc_ref = firestore.client().collection(u'cities').document(u'LA')
    doc = doc_ref.get()
    if doc.exists:
        return f'Document data: {doc.to_dict()}'
    else:
        return u'No such document!'

# An example of saving data to Firebase
# Taken from Firebase documentation
# This should be a POST method...will change later
@app.route('/example/write', methods=['GET'])
def examnpleWrite():
    data = {
        u'name': u'Los Angeles',
        u'state': u'CA',
        u'country': u'USA'
    }

    # Add a new doc in collection 'cities' with ID 'LA'
    firestore.client().collection(u'cities').document(u'LA').set(data)
    return 'Saved to Firebase'

if __name__ == '__main__':
    app.run()
