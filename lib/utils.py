from random import randint
from flask import current_app
from flask_mail import Mail, Message
from firebase_admin import auth, firestore

def sendMail(subject, sender, recipients, body):
    mail = Mail(current_app)
    msg = Message(subject, sender=sender, recipients=recipients)
    msg.body = body
    mail.send(msg)

def saveVerificationCode(uid):
    code = randint(100000, 999999)
    data = {
        u'code': code
    }
    firestore.client().collection(u'verification').document(uid).set(data)
    return code

def sendVerificationMail(name, email, code):
    subject = 'Please verify your email for BarkFinder'
    sender = 'legbarkr@gmail.com'
    recipients = [email]
    body = '''Hey {}! Thank you for signing up for BarkFinder.
               In order to use our sevices, could you please verify your email address by logging in and entering this code {}'''.format(name, code)
    sendMail(subject, sender, recipients, body)

def userLoggedInAndVerfied(token):
    # Need frontend to test this
    # decoded_token = auth.verify_id_token(token)
    # uid = decoded_token['uid']
    # isVerified = auth.get_user(uid).email_verified
    return True     #placeholder