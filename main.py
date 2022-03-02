import requests, json, subprocess, re
import paho.mqtt.client as mqtt

def OpenHayStackLocation():
    # TODO: replace with OpenHaystack script
    return 0, 0

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("/data")

def on_message(client, userdata, msg):
    if msg.topic == "/data":
        loc_lat, loc_lon = None, None
        try:
            subprocess.run("./OpenHaystack.app/Contents/MacOS/OpenHaystack > extract.txt", capture_outout=True, shell=True, timeout=5)
        except Exception as e:
            pass
        with open("extract.txt", "r") as output:
            lines = output.readlines()
        for line in reversed(lines):
            if "FindMyLocationReport" in line:
                loc_lat = re.findall("latitude: (-?[0-9]*\.[0-9]*)", line)[0]
                loc_lon = re.findall("longitude: (-?[0-9]*\.[0-9]*)", line)[0]
                break
        subprocess.run("pkill OpenHaystack", shell=True)
        data = json.loads(msg.payload)
        firebase_url = "https://leg-barkr.nw.r.appspot.com/readings/save"
        firebase_headers = {
            "Content-Type": "application/json",
            "Device-ID": data["devID"]
        }
        firebase_data = {
            "air_temp": data["air_temp"],
            "cumulative_steps_today": data["day_steps"],
            "humidity": data["hum_perc"],
            "latitude": float(loc_lat),
            "longitude": float(loc_lon),
            "skin_temp": data['pet_temp']
        }
        r = requests.post(url = firebase_url, json = firebase_data, params = None, headers = firebase_headers) # add any other necessary values in request
        print(r.status_code, r.reason, r.text)

client = mqtt.Client("DataPuller")
client.on_connect = on_connect
client.on_message = on_message
client.connect("add8.duckdns.org", 8883, 60)
client.loop_forever()
