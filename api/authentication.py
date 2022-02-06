import json
import lib.mail
from random import randint
from flask import Response, Blueprint, request
from firebase_admin import firestore, auth
from firebase_admin._auth_utils import EmailAlreadyExistsError

authentication = Blueprint('authentication', __name__)

@authentication.route('/authentication/register', methods=['POST'])
def register():
    body = request.json
    if body is None:
        return Response("{'error':'Invalid request - please provide a body'}", status=400, mimetype='application/json')

    email = body['email']
    password = body['password']
    name = body['name']
    deviceId = body['deviceid']

    # Some fields are not present
    if email is None or password is None or name is None or deviceId is None:
        return Response("{'error':'Entries missing'}", status=400, mimetype='application/json')

    # Register user with Firebase authentication
    try:
        user = auth.create_user(
            email=email,
            email_verified=False,
            password=password,
            display_name=name,
            disabled=False)
    except EmailAlreadyExistsError:
        return Response("{'error':'User with given email address already exists'}", status=409, mimetype='application/json')

    # Prompt the user to verify their email
    code = randint(100000, 999999)
    data = {
        u'code': code
    }
    firestore.client().collection(u'verification').document(user.uid).set(data)

    subject = 'Please verify your email for BarkFinder'
    sender = 'legbarkr@gmail.com'
    recipients = [email]
    body = '''Hey {}! Thank you for signing up for BarkFinder.
               In order to use our sevices, could you please verify your email address by logging in and entering this code {}'''.format(name, code)
    lib.mail.send(subject, sender, recipients, body)

    # Link the user to the device
    data = {
        u'devices': [deviceId]
    }
    firestore.client().collection(u'devices').document(user.uid).set(data)

    # User successfully created and linked to device, return 201
    resp = {"uid": user.uid}
    return Response(json.dumps(resp), status=201, mimetype='application/json')