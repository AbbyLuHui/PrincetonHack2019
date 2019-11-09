# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
#this editor takes in an HTML form data and then uses the number to make a call. 

from flask import Flask, jsonify, redirect, url_for, request 
from twilio.rest import Client

app = Flask(__name__)

@app.route('/success/<name>')
def success(name):
   return 'welcome %s' % name

@app.route('/login/',methods = ['POST', 'GET'])
def login():
    if request.method == 'POST': 
        user = request.form['emergency']
        print("HAHA you are good.")
        return redirect(url_for('success',name = user))
    else:
        user = request.args.get('')
        name1 = str(user)
        account_sid = 'AC102092b89629bd04c1bb77a847531075'
        auth_token = 'f69ea2ad3172f786ff3f3e60c69d4934'
        client = Client(account_sid, auth_token)
        call = client.calls.create(url='http://demo.twilio.com/docs/voice.xml', to=name1, from_='+12562696834')
        print(call.sid)
        return redirect(url_for('success',name = user))


if __name__ == '__main__':
    app.run()





