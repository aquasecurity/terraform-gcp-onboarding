import time
import json
import sys
import hmac
import hashlib
import http.client
import ssl

# Retrieve the query parameters
query                             = json.loads(sys.stdin.read())
aqua_api_key                      = query.get("api_key", "")
aqua_api_secret                   = query.get("api_secret", "")
aqua_autoconnect_url              = query.get("autoconnect_url", "").split("//")[1]
service_account_key               = query.get("service_account_key", "")
client_config                     = query.get("client_config", "")
cspm_group_id                     = query.get("cspm_group_id", "")
configuration_id                  = query.get("configuration_id", "")
scan_mode                         = query.get("scan_mode", "")
project_id                        = query.get("project_id", "")
organization_onboarding           = query.get("organization_onboarding", "") == "True"
organization_id                   = query.get("organization_id", "")
organization_projects             = query.get("organization_projects", "").split(",")
additional_resource_tags          = query.get("additional_resource_tags", "")


def get_signature(api_secret, timestamp, path, method, body=''):
    enc = timestamp + method + path + body
    enc_b = bytes(enc, 'utf-8')
    secret = bytes(api_secret, 'utf-8')
    sig = hmac.new(secret, enc_b, hashlib.sha256).hexdigest()
    return sig


def get_headers(cspm_key, cspm_method='GET', body_cspm=''):
    timestamp = str(int(time.time() * 1000))
    internal_signature = get_signature(aqua_api_secret, timestamp, "/v2/internal_apikeys",  method="GET")

    cspm_path = "/v2/keys"
    if cspm_key is not None:
        cspm_path += "/" + cspm_key

    signature_cspm_keys = get_signature(
        api_secret=aqua_api_secret,
        timestamp =timestamp,
        path      =cspm_path,
        method    =cspm_method,
        body      =body_cspm
    )

    headers = {
        "X-API-Key": aqua_api_key,
        "X-Authenticate-Api-Key-Signature": internal_signature,
        "X-Register-New-Cspm-Signature": signature_cspm_keys,
        "X-Timestamp": timestamp,
        "Content-Type": "application/json"
    }

    return headers


def http_request(url, path, method, headers, body):
    connection = http.client.HTTPSConnection(url, context=ssl._create_unverified_context())
    connection.request(method, path, body, headers)
    response = connection.getresponse()
    data = {"status": response.status, "body": response.read().decode('utf-8'), "reason": response.reason}
    connection.close()

    return data


def trigger_discovery():
    parsed_json = json.loads(service_account_key)
    project_type = parsed_json["type"]
    client_email = parsed_json["client_email"]
    private_key = parsed_json["private_key"].replace("\n", "\\n")
    name = f'{project_id}:{client_email}'
    body_cspm = ('{"autoconnect":true,"cloud":"google","connection":{"google":{"client_email":"' +
                 client_email + '","private_key":"' + private_key + '","project_id":"' + project_id +
                 '","type":"' + project_type + '"}},"group_id":' + str(int(cspm_group_id)) + ',"name":"' + name + '"}')
    headers = get_headers(None, "POST", body_cspm)

    body = json.dumps({
        "cloud": "google",
        "project_to_onboard": project_id,
        "configuration_id": configuration_id,
        "scan_mode": scan_mode,
        "deployment_method": "Terraform",
        "cspm_group_id": int(cspm_group_id),
        "organization_onboarding": organization_onboarding,
        "additional_resource_tags": additional_resource_tags,
        "organization_id": organization_id,
        "payload": service_account_key,
        "payload_vm": client_config,
    })

    response = http_request(aqua_autoconnect_url, "/discover/google", "POST", headers, body)
    result = f'received response: status {response["status"]}, body: {response["body"]}'

    return result


def get_organization_projects_aqua(_organization_id):
    path = (f"/connected-accounts/provider?"
            f"cloud_provider=google&"
            f"integration_type=auto_discovery&"
            f"organization_id={_organization_id}")

    response = http_request(aqua_autoconnect_url, path, "GET", get_headers(cspm_key=None), None)

    result = []
    err = None
    if response["status"] == 200:
        try:
            data_dict = json.loads(response["body"])
            result = [
                {"id": account["CSPMData"]["role_arn"].split(":")[0], "cspm_key": account["CSPMData"]["id"]}
                    for account in data_dict["cloud_accounts_data"]
            ]
        except json.JSONDecodeError:
            err = "get_organization_projects_aqua:: Response content is not valid JSON"
    else:
        err = "get_organization_projects_aqua:: Error: " + str(response["status"]) + " " + response["reason"]

    return result, err


def offboard_project(project):

    method = "DELETE"
    body = json.dumps({
        "cloud_accounts": [
            {
                "cloud_account_id": project["id"],
                "cspm_key_id": str(project["cspm_key"])
            }
        ]
    })
    cspm_key = str(project["cspm_key"])

    response = http_request(aqua_autoconnect_url, "/discover", method, get_headers(cspm_key, cspm_method=method), body)

    err = None
    result = None
    if response["status"] == 200:
        try:
            result = json.loads(response["body"])
        except json.JSONDecodeError:
            err = "offboard_project:: Response content is not valid JSON"
    else:
        err = "offboard_project:: Error: " + str(response["status"]) + " " + response["reason"]

    return result, err


def main():
    aqua_connected_accounts, err = get_organization_projects_aqua(organization_id)
    if err:
        onboarding_status = err
    else:
        if organization_onboarding:
            offboard_projects = []
            offboard_project_results = []
            if not err:
                for project in aqua_connected_accounts:
                    if project["id"] not in organization_projects:
                        offboard_projects.append(project)

                for project in offboard_projects:
                    offboard_project_result, err = offboard_project(project)
                    offboard_project_results.append([offboard_project_result, err])

        if project_id not in [project["id"] for project in aqua_connected_accounts]:
            onboarding_status = trigger_discovery()
        else:
            onboarding_status = "Project already connected"

    output = {
        "status": onboarding_status
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
