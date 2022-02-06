from flask import current_app
from flask_mail import Mail, Message

def send(subject, sender, recipients, body):
    mail = Mail(current_app)
    msg = Message(subject, sender=sender, recipients=recipients)
    msg.body = body
    mail.send(msg)