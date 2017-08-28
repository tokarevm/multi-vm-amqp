#!/usr/bin/env python
import sys
from pyzabbix import ZabbixAPI, ZabbixAPIException

if len(sys.argv) == 2 and sys.argv[1].isdigit():
	treshold=int(sys.argv[1])
else:
	print "Wrong parameters"
	sys.exit()

# The hostname at which the Zabbix web interface is available
zabbix_server = 'http://localhost/zabbix'

# Enter administrator credentials for the Zabbix Web Frontend
username = "Admin"
password = "zabbix"
host_name = "central"

zapi = ZabbixAPI(zabbix_server)
zapi.login(username, password)

hosts = zapi.host.get(filter={"host": host_name}, selectInterfaces=["interfaceid"])

name = "test"

if hosts:
    host_id = hosts[0]["hostid"]
    print("Found host id {0}".format(host_id))
    item = zapi.item.get(filter={"hostid": host_id, "key_": 'rabbitmaxq', "output": "extend"})
    if not item:
        try:
            item = zapi.item.create(
                hostid=host_id,
                name='Rabbitmq queue length',
                description='Rabbitmq queue length',
                key_='rabbitmaxq[%d]' % treshold,
                type=0,
                interfaceid=hosts[0]["interfaces"][0]["interfaceid"],
                value_type=3,
                delay=10
            )
        except ZabbixAPIException as e:
            print str(e)
            sys.exit()
    try:
        item = zapi.trigger.create(
            host=host_id,
            name='Rabbitmq queue treshold exceeded',
            description='Rabbitmq queue treshold exceeded',
            status=0,
            type=0,
            priority=3,
            expression='{central:rabbitmaxq[%d].last(0)}>%d' % (treshold, treshold)
        )
    except ZabbixAPIException as e:
        print str(e)
        sys.exit()

