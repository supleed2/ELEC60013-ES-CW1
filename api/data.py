import time
import json
from datetime import datetime, time, timedelta
from flask import Response, Blueprint, request
from firebase_admin import firestore

data = Blueprint('data', __name__)

@data.route('/readings/save', methods=['POST'])
def uploadReadings():
    deviceId = request.headers.get('Device-ID')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    # Check that measurements are provided
    body = request.json
    if body is None:
        resp = {'error': 'Invalid request - please provide a body'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')
    body['timestamp'] = datetime.now().timestamp()

    # Save all the measurements
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
    deviceId = request.headers.get('Device-ID')
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

@data.route('/readings/location/last', methods=['GET'])
def getLastLocation():
    deviceId = request.headers.get('Device-ID')
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

@data.route('/readings/steps/today', methods=['GET'])
def getStepsToday():
    deviceId = request.headers.get('Device-ID')
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

@data.route('/readings/steps/last-five-days', methods=['GET'])
def getStepsLastFiveDays():
    deviceId = request.headers.get('Device-ID')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    upcomingMidnight = datetime.combine(datetime.today(), time.min) + timedelta(days=1)
    doc = firestore.client().collection(u'readings').document(deviceId).get()

    if doc.exists:
        data = doc.to_dict()['data']
        listOfDailySteps = []

        for i in range(0, 5):
            found = False
            previousMidnight = upcomingMidnight - timedelta(days=1)
            print(previousMidnight.timestamp())
            steps = 0
            for reading in reversed(data):
                if reading['timestamp'] <= upcomingMidnight.timestamp() and reading['timestamp'] >= previousMidnight.timestamp() and not found:
                    steps = reading['cumulative_steps_today']
                    found = True
            listOfDailySteps.append(steps)
            upcomingMidnight = previousMidnight
    else:
        listOfDailySteps = [0] * 5

    results = {'daily_steps': listOfDailySteps}
    return Response(json.dumps(results), status=200, mimetype='application/json')

@data.route('/readings/metrics-summary', methods=['GET'])
def getMetricsSummary():
    deviceId = request.headers.get('Device-ID')
    if deviceId is None:
        resp = {'error': 'Device not specified'}
        return Response(json.dumps(resp), status=400, mimetype='application/json')

    upcomingMidnight = datetime.combine(datetime.today(), time.min) + timedelta(days=1)
    lastMidnight = datetime.combine(datetime.today(), time.min)
    doc = firestore.client().collection(u'readings').document(deviceId).get()

    if doc.exists:
        allData = doc.to_dict()['data']
        currentDayData = [x for x in allData if x['timestamp'] <= upcomingMidnight.timestamp() and x['timestamp'] >= lastMidnight.timestamp()]
        if len(currentDayData) >= 1:
            maxAirTemp = max(currentDayData, key=lambda x: x['air_temp'])['air_temp']
            maxSkinTemp = max(currentDayData, key=lambda x: x['skin_temp'])['skin_temp']
            maxHumidity = max(currentDayData, key=lambda x: x['humidity'])['humidity']
            minAirTemp = min(currentDayData, key=lambda x: x['air_temp'])['air_temp']
            minSkinTemp = min(currentDayData, key=lambda x: x['skin_temp'])['skin_temp']
            minHumidity = min(currentDayData, key=lambda x: x['humidity'])['humidity']
            results = {
                'last_air_temp': currentDayData[-1]['air_temp'], 'min_air_temp': minAirTemp, 'max_air_temp': maxAirTemp,
                'last_skin_temp': currentDayData[-1]['skin_temp'], 'min_skin_temp': minSkinTemp, 'max_skin_temp': maxSkinTemp,
                'last_humidity': currentDayData[-1]['humidity'], 'min_humidity': minHumidity, 'max_humidity': maxHumidity
            }
            return Response(json.dumps(results), status=200, mimetype='application/json')
        else:
            return Response(json.dumps({'error': 'Could not get data from database'}), status=500, mimetype='application/json')
    else:
        return Response(json.dumps({'error': 'Could not get data from database'}), status=500, mimetype='application/json')




