import json
import lib.utils
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

    # Prompt the user to get verified
    code = lib.utils.saveVerificationCode(user.uid)
    lib.utils.sendVerificationMail(name, email, code)

    # Link the user to the device
    data = {
        u'devices': [deviceId]
    }
    firestore.client().collection(u'devices').document(user.uid).set(data)

    # User successfully created and linked to device, return 201
    resp = {"uid": user.uid}
    return Response(json.dumps(resp), status=201, mimetype='application/json')

@authentication.route('/authentication/verify', methods=['POST'])
def verify():
    body = request.json
    if body is None:
        return Response("{'error':'Invalid request - please provide a body'}", status=400, mimetype='application/json')

    uid = body['uid']
    code = body['code']

    doc = firestore.client().collection(u'verification').document(uid).get()
    if doc.exists:
        if doc.to_dict()['code'] == code:
            auth.update_user(uid, email_verified=True)
            firestore.client().collection(u'verification').document(uid).delete()
            return Response("{'error':'User verified'}", status=200, mimetype='application/json')
        else:
            return Response("{'error':'Invalid code'}", status=400, mimetype='application/json')
    else:
        user = auth.get_user(uid)
        code = lib.utils.saveVerificationCode(user.uid)
        lib.utils.sendVerificationMail(user.display_name, user.email, code)
        return Response("{'error':'Server couldn't find code, creating new one and sending email'}", status=500, mimetype='application/json')

