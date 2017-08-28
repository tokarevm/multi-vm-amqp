# Vagrant boxes with AMQP broker, message publisher, message consumer and a monitoring system

# About

This boxes contain a vagrant / ansible recipe that allows to create a develop enviroment with rabbitmq server, publisher and consumer applications, zabbix server

# Install

* Download and install [Vagrant](http://downloads.vagrantup.com/)
* Download and install  [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install vagrant-hostmanager plugin (vagrant plugin install vagrant-hostmanager)
* Clone the project ```git clone https://github.com/tokarevm/multi-vm-amqp.git```
* In the project dir run ```vagrant up```

## Installed services

### RabbitMQ

host: 10.0.0.10
port: 5672

### Zabbix server

host: 10.0.0.10
port 10050

### Zabbix web management

URL: http://localhost:8080/zabbix
username: Admin
password: zabbix

