import requests
import json

url = "https://api.thingspeak.com/channels/2304645/fields/1.json?results=2"

response = requests.get(url).text


data = json.loads(response)

last_entry = data["feeds"][-1]

field1_value = last_entry["field1"]

print(f"Last field1 value: {field1_value}")
