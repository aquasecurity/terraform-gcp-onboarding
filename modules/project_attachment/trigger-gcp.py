import time
import json
import sys
import hmac
import hashlib
import http.client
import ssl

timestamp = str(int(time.time() * 1000))

# Retrieve the query parameters
query = json.loads(sys.stdin.read())
api_key = query.get("api_key", "")
api_secret = query.get("api_secret", "")
autoconnect_url = query.get("autoconnect_url", "")
service_account_key = query.get("service_account_key", "")
client_config = query.get("client_config", "")
cspm_group_id = query.get("cspm_group_id", "")
configuration_id = query.get("configuration_id", "")
scan_mode = query.get("scan_mode", "")
project_id = query.get("project_id", "")
organization_id = query.get("organization_id", "")
organization_onboarding_str = query.get("organization_onboarding", "")
additional_resource_tags = query.get("additional_resource_tags", "")

if organization_onboarding_str.lower() == "true":
    organization_onboarding = True
elif organization_onboarding_str.lower() == "false":
    organization_onboarding = False

parsed_json = json.loads(service_account_key)
type = parsed_json["type"]
client_email = parsed_json["client_email"]
private_key = parsed_json["private_key"].replace("\n", "\\n")
name = f'{project_id}:{client_email}'

def get_signature(aqua_secret, tstmp, path, method, body=''):
    enc = tstmp + method + path + body
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(aqua_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    return sig

internal_signature = get_signature(api_secret, timestamp, "/v2/internal_apikeys", "GET")

body_cspm = '{"autoconnect":true,"cloud":"google","connection":{"google":{"client_email":"' + client_email + '","private_key":"' + private_key + '","project_id":"' + project_id + '","type":"' + type + '"}},"group_id":' + str(int(cspm_group_id)) + ',"name":"' + name + '"}'


body = json.dumps({
    "configuration_id": configuration_id,
    "cspm_group_id": int(cspm_group_id),
    "organization_id": organization_id,
    "project_to_onboard": project_id,
    "payload": service_account_key,
    "payload_vm": client_config,
    "scan_mode": scan_mode,
    "organization_onboarding": organization_onboarding,
    "additional_resource_tags": additional_resource_tags,
    "project_to_onboard": project_id,
    "deployment_method": "Terraform"
})

signature_cspm_keys = get_signature(api_secret, timestamp, "/v2/keys", "POST", body_cspm)

headers = {
    "X-API-Key": api_key,
    "X-Authenticate-Api-Key-Signature": internal_signature,
    "X-Register-New-Cspm-Signature": signature_cspm_keys,
    "X-Timestamp": timestamp,
    "Content-Type": "application/json"
}

conn = http.client.HTTPSConnection(autoconnect_url.split("//")[1], context = ssl._create_unverified_context())
path = "/discover/google"
method = "POST"

conn.request(method, path, body=body, headers=headers)
response = conn.getresponse()
onboarding_status = 'received response: status {}, body: {}'.format(response.status, response.read().decode("utf-8"))

conn.close()


output = {
    "status": onboarding_status
}

print(json.dumps(output))