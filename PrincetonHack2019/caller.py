from flask import Flask
from flask import jsonify
from flask import render_template
from flask import request
from flask import url_for

from twilio.twiml.voice_response import VoiceResponse
from twilio.rest import Client

# Declare and configure application
app = Flask(__name__)


# Route for Click to Call demo page.

# Voice Request URL
@app.route('/location/', methods=['POST'])
def location():
    # Get phone number we need to call
    phone_number = request.form.get('phoneNumber', None)
    print(phone_number)
    phone_number = '+19294338832'
    try:
        twilio_client = Client(app.config['AC102092b89629bd04c1bb77a847531075'],
                               app.config['7ea5fc7a1042bc5881104a1c6ace0e6b'])
    except Exception as e:
        msg = 'Missing configuration variable: {0}'.format(e)
        return jsonify({'error': msg})

    try:
        print("Trying")
        twilio_client.calls.create(url=url_for('.outbound', _external=True),to=phone_number, from_=app.config['+12562696834']
                                   )
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


if __name__ == '__main__':
    app.run(debug=True)
