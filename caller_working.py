import os
from flask import Flask
from flask import jsonify
from flask import render_template
from flask import request
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
class Location(Resource):
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
                                       url=url_for('.outbound',
                                                   _external=True))
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

api.add_resource(Location, '/location/')

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True, port=80)