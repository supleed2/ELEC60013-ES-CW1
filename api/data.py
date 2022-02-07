import datetime
from flask import Response, Blueprint, request
from firebase_admin import firestore

data = Blueprint('data', __name__)

@data.route('/readings/save', methods=['POST'])
def uploadReadings():
    deviceId = request.headers.get('deviceid')
    if deviceId is None:
        return Response("{'error':'Device not specified'}", status=400, mimetype='application/json')

    body = request.json
    if body is None:
        return Response("{'error':'Invalid request - please provide a body'}", status=400, mimetype='application/json')
    body['timestamp'] = datetime.datetime.now()

    doc = firestore.client().collection(u'readings').document(deviceId).get()
    if doc.exists:
        list = doc.to_dict()['data']
        list.append(body)
        data = list
    else:
        data = [body]

    upload = {'data': data}
    firestore.client().collection(u'readings').document(deviceId).set(upload)
    return Response("{'success':'Data saved'}", status=200, mimetype='application/json')
