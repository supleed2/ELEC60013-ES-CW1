from flask import Flask

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

app = Flask(__name__)
firebase = firebase_admin.initialize_app(credentials.Certificate('firebase-key.json'))

@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World! I am the dog you tracked with the amazing sensor from LEG industries...kidding this is just the home page :)'

# An example of reading data from Firebase
# Taken from Firebase documentation
@app.route('/example/read', methods=['GET'])
def exampleRead():
    doc_ref = firestore.client().collection(u'cities').document(u'LA')
    doc = doc_ref.get()
    if doc.exists:
        return f'Document data: {doc.to_dict()}'
    else:
        return u'No such document!'

# An example of saving data to Firebase
# Taken from Firebase documentation
# This should be a POST method...will change later
@app.route('/example/write', methods=['GET'])
def examnpleWrite():
    data = {
        u'name': u'Los Angeles',
        u'state': u'CA',
        u'country': u'USA'
    }

    # Add a new doc in collection 'cities' with ID 'LA'
    firestore.client().collection(u'cities').document(u'LA').set(data)
    return 'Saved to Firebase'

if __name__ == '__main__':
    app.run()
