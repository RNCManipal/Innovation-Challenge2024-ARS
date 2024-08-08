from flask import Flask, request, jsonify
from flask_mail import Mail, Message
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

app.config['MAIL_SERVER'] = 'smtp.office365.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = 'rnc.ars@outlook.com'
app.config['MAIL_PASSWORD'] = 'ars@12345'
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False

mail = Mail(app)

@app.route('/send-email', methods=['POST'])
def send_email():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'Invalid or missing JSON payload'}), 400

        receiver_email = data.get('receiver_email')
        coordinates = data.get('coordinates')
        if not receiver_email or not coordinates:
            return jsonify({'error': 'Missing receiver_email or coordinates in request'}), 400

        latitude = coordinates.get('latitude')
        longitude = coordinates.get('longitude')
        if not latitude or not longitude:
            return jsonify({'error': 'Missing latitude or longitude in coordinates'}), 400

        msg = Message('EMERGENCY ALERT', sender='rnc.ars@outlook.com', recipients=[receiver_email])
        msg.body = f"EMERGENCY ALERT\nAmbulance assistance required at the current location:\nLatitude: {latitude}, Longitude: {longitude}\n\nGoogle Maps: https://maps.google.com/?q={latitude},{longitude}"
        mail.send(msg)
        return jsonify({'message': 'Email sent successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


