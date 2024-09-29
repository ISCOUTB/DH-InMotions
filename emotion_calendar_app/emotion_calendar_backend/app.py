from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///emotions.db'
db = SQLAlchemy(app)

class Emotion(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date_time = db.Column(db.String(50), nullable=False)
    emotion = db.Column(db.String(20), nullable=False)
    note = db.Column(db.String(200), nullable=True)

@app.route('/add_emotion', methods=['POST'])
def add_emotion():
    data = request.get_json()
    new_emotion = Emotion(
        date_time=data['date_time'],
        emotion=data['emotion'],
        note=data['note']
    )
    db.session.add(new_emotion)
    try:
        db.session.commit()
        return jsonify({"message": "Emoción guardada exitosamente"}), 201
    except:
        db.session.rollback()
        return jsonify({"message": "Error al guardar la emoción"}), 400

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)