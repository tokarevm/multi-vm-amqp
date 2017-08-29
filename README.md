# Vagrant boxes with AMQP broker, message publisher, message consumer and a monitoring system

# About

This boxes contain a vagrant / ansible recipe that allows to create a develop enviroment with rabbitmq server, publisher and consumer applications, zabbix server

# Install

* Download and install [Vagrant](https://www.vagrantup.com/downloads.html)
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

## Monitoring
  
Central host has item "Rabbitmq queue" that shows current rabbitmq queue length. It's updated every 10 seconds.  
If queue length above the treshold then trigger will fire and current queue length will write to log file (/tmp/rabbitmq_queue.log)  
Basic parameters of both central and worker hosts are monitoring.  

## Installed Applications

### Consumer

Consumer app will start automatically after VM deployment. App log file consumer.log is located in the /opt/myapp/ directory.  
Steps for manually start app:  
* Login to worker host: vagrant ssh worker
* Change directory: cd /opt/myapp/
* Run application: python consumer.py

### Publisher

Steps for manually start app:  
* Login to central host: vagrant ssh central
* Change directory: cd /opt/myapp/
* Run application: java -classpath .:amqp-client-4.0.2.jar:slf4j-api-1.7.21.jar:slf4j-simple-1.7.22.jar Send <number of seconds to delay>

### Stress test

stress.sh is bash script that generate random data and publish it messeges to AMQP queue. It is located on central host in the /opt/myapp directory.  
Script has two parameters:  
- worker sleep time  
- time between sending data to queue

## Spin-up extra

If needs to run more workers to consume message on parallel with the original worker run script spinup.sh. This script automatically spin-up new VM, register it in Zabbix server and start consumer app.
