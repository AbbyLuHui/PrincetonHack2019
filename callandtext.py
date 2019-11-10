# -*- coding: utf-8 -*-
"""
Created on Sat Nov  9 23:05:16 2019

@author: jerry
"""

import os
from flask import Flask
from flask import jsonify
from flask import render_template
from flask import request
from twilio.twiml.messaging_response import MessagingResponse
from flask import url_for
from flask_restful import Resource, Api
from dotenv import load_dotenv

from twilio.twiml.voice_response import VoiceResponse
from twilio.rest import Client

# Declare and configure application
app = Flask(__name__)
api = Api(app)
load_dotenv()

# Route for Click to Call demo page.
print("------START------")
# Voice Request URL
#@app.route('/location/', methods=['POST'])
class call(Resource):
    def post(self):
        # Get phone number we need to call
        phone_number = request.form.get('phoneNumber', None)
        print(phone_number)
        phone_number = os.getenv("PHONE_NUMBER")
        print(phone_number)
        try:
            twilio_client = Client(os.getenv("ACCOUNT_SID"),
                                   os.getenv("ACCOUNT_TOKEN"))
        except Exception as e:
            msg = 'Missing configuration variable: {0}'.format(e)
            return jsonify({'error': msg})

        try:
            twilio_client.calls.create(from_=os.getenv("TWILIO_PHONE"),
                                    to=phone_number,
                                    url=url_for('.outbound',_external=True))
            
            print("SENT")
        except Exception as e:
            app.logger.error(e)
            return jsonify({'error': str(e)})

        return jsonify({'message': 'Call incoming!'})


@app.route('/outbound', methods=['POST'])
def outbound():
    response = VoiceResponse()

    response.say("your relative is in trouble.",
            voice='alice')
    '''
    # Uncomment this code and replace the number with the number you want
    # your customers to call.
    response.number("+16518675309")
    '''
    return str(response)



#@app.route('/text', methods=['POST'])
class text(Resource):
    def post(self):
        # Get phone number we need to call
        phone_number = request.form.get('phoneNumber', None)
        print(phone_number)
        phone_number = os.getenv("PHONE_NUMBER")
        print(phone_number)
        try:
            twilio_client = Client(os.getenv("ACCOUNT_SID"),
                                   os.getenv("ACCOUNT_TOKEN"))
        except Exception as e:
            msg = 'Missing configuration variable: {0}'.format(e)
            return jsonify({'error': msg})

        try:
      #      twilio_client.messages.create(body = "Relative out of range", from_= #os.getenv("TWILIO_PHONE"), to=phone_number,url=url_for('.incoming_sms',
         #   _external=True))
             twilio_client.messages.create(body = "Relative out of range", from_= os.getenv("TWILIO_PHONE"), to=phone_number)
             
             print("SENT")
        except Exception as e:
            app.logger.error(e)
            return jsonify({'error': str(e)})

        return jsonify({'message': 'Message incoming!'})


#def outbound():
 #   response = VoiceResponse()
#
 ##          voice='alice')
   # '''
    # Uncomment this code and replace the number with the number you want
    # your customers to call.
  #  response.number("+16518675309")
  #  '''
  #  return str(response)

#api.add_resource(call, '/call/')

@app.route('/', methods=['GET', 'POST'])
def sms():
    """Send a dynamic reply to an incoming text message"""
    # Get the message the user sent our Twilio number
    body = request.values.get('Body', None)

        # Start our TwiML response
    resp = MessagingResponse()

        # Determine the right reply for this message
    if body == '1':
        resp.message("Okay! we are calling your relative!!")
        #call = client.calls.create(
        #                url='http://demo.twilio.com/docs/voice.xml',
        #                to=os.getenv("leElderly"),
         #               from_=phone_number)
        
    elif body == '2':
        resp.message("Here is the location of your relative!!")
        #resp.message(str(location))

    return str(resp)

api.add_resource(call, '/call/')
api.add_resource(text, '/text/')

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True, port=5000)
