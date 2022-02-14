import time
import json
from flask import Response, Blueprint, request
from firebase_admin import firestore

data = Blueprint('data', __name__)

@data.route('/readings/save', methods=['POST'])
def uploadReadings():
    deviceId = request.headers.get('deviceid')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    body = request.json
    if body is None:
        resp = {'error': 'Invalid request - please provide a body'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')
    body['timestamp'] = time.time()

    doc = firestore.client().collection(u'readings').document(deviceId).get()
    if doc.exists:
        list = doc.to_dict()['data']
        list.append(body)
        data = list
    else:
        data = [body]

    upload = {'data': data}
    firestore.client().collection(u'readings').document(deviceId).set(upload)
    resp = {'success': 'Data saved'}
    return Response(json.dumps(resp), status=200, mimetype='application/json')

@data.route('/readings/getall', methods=['GET'])
def getAllReadings():
    deviceId = request.headers.get('deviceid')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    doc = firestore.client().collection(u'readings').document(deviceId).get()
    if doc.exists:
        data = doc.to_dict()['data']
    else:
        data = []

    results = {'data': data}
    return Response(json.dumps(results), status=200, mimetype='application/json')

@data.route('/readings/last/location', methods=['GET'])
def getLastLocation():
    deviceId = request.headers.get('deviceid')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    doc = firestore.client().collection(u'readings').document(deviceId).get()
    if doc.exists:
        data = doc.to_dict()['data']
        lastEntry = data[-1]
        lat = lastEntry['latitude']
        lon = lastEntry['longitude']
    else:
        lat = -1.0
        lon = -1.0

    results = {'latitude': lat, 'longitude': lon}
    return Response(json.dumps(results), status=200, mimetype='application/json')

@data.route('/readings/last/steps', methods=['GET'])
def getStepsToday():
    deviceId = request.headers.get('deviceid')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    doc = firestore.client().collection(u'readings').document(deviceId).get()
    if doc.exists:
        data = doc.to_dict()['data']
        lastEntry = data[-1]
        steps = lastEntry['cumulative_steps_today']
    else:
        steps = 0

    results = {'cumulative_steps_today': steps}
    return Response(json.dumps(results), status=200, mimetype='application/json')
