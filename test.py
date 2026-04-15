import requests
import json

url = "https://rhzetnb7el.execute-api.ap-south-1.amazonaws.com/dev/demo-path"
payload = {"min": 5, "max": 50}
headers = {'Content-Type': 'application/json'}

response = requests.post(url, data=json.dumps(payload), headers=headers)

print(f"Status Code: {response.status_code}")
print(f"Response: {response.json()}")
