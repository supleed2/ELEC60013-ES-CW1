import requests
import json
import paho.mqtt.client as mqtt

def OpenHayStackLocation():
    # TODO: replace with OpenHaystack script
    return 0, 0

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("/data")

def on_message(client, userdata, msg):
    if msg.topic == "/data":
        data = json.loads(msg.payload)
        firebase_url = "https://leg-barkr.nw.r.appspot.com/readings/save"
        firebase_headers = {
            "Content-Type": "application/json",
            "Device-ID": data["devID"]
        }
        loc_lat, loc_lon = OpenHayStackLocation()
        firebase_data = {
            "air_temp": data["air_temp"],
            "cumulative_steps_today": data["day_steps"],
            "humidity": data["hum_perc"],
            "latitude": loc_lat,
            "longitude": loc_lon,
            "skin_temp": data['pet_temp']
        }
        r = requests.post(url = firebase_url, json = firebase_data, params = None, headers = firebase_headers) # add any other necessary values in request
        print(r.status_code, r.reason, r.text)

client = mqtt.Client("DataPuller")
client.on_connect = on_connect
client.on_message = on_message
client.connect("add8.duckdns.org", 8883, 60)
client.loop_forever()
