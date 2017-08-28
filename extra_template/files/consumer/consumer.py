#!/usr/bin/env python
import pika
import time

QUEUE_NAME = "test_queue"

connection = pika.BlockingConnection(pika.ConnectionParameters(host='central'))
channel = connection.channel()

channel.queue_declare(queue=QUEUE_NAME)

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)
    if body.isdigit():
        time.sleep(int(body))
        channel.basic_ack(delivery_tag = method.delivery_tag)
    else:
        print("Wrong timeout!")

channel.basic_consume(callback,
                      queue=QUEUE_NAME)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()

