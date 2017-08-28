#!/bin/sh
# Script creates new host configuration in zabbix server

URL='http://central/zabbix/api_jsonrpc.php'
HEADER='Content-Type:application/json'

USER='"zabbix"'
PASS='"zabbix"'

WORKER_HOST='worker'
WORKER_IP='10.0.0.11'

autentication()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "user.login",
        "params": {
            "user": '$USER',
            "password": '$PASS'
        },
        "id": 0
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" | cut -d '"' -f8
}
TOKEN=$(autentication)

create_hosts()
{
    JSON='
    {
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": "'$WORKER_HOST'",
            "status": 1,
            "interfaces": [
                {
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": "'$WORKER_IP'",
                    "dns": "",
                    "port": 10050
                }
            ],
            "groups": [
                {
                    "groupid": 2
                }
            ],
            "templates": [
                {
                    "templateid": 10001
                }
            ]
        },
        "auth": "'$TOKEN'",
        "id": 1        
    }
    '
    curl -s -X POST -H "$HEADER" -d "$JSON" "$URL" > /dev/null
}

create_hosts
echo "Hosts create successfully"

