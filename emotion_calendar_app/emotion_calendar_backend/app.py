# app.py

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///emotions.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'tu_clave_secreta'  # Cambia esto en producción
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(days=1)

db = SQLAlchemy(app)
jwt = JWTManager(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(200), nullable=False)

class Emotion(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    emotion = db.Column(db.String(50), nullable=False)

with app.app_context():
    db.create_all()

@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    hashed_password = generate_password_hash(data['password'], method='sha256')
    new_user = User(name=data['name'], email=data['email'], password=hashed_password)
    db.session.add(new_user)
    try:
        db.session.commit()
        return jsonify({"message": "Usuario registrado exitosamente"}), 201
    except:
        db.session.rollback()
        return jsonify({"message": "Error al registrar usuario"}), 400

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()
    if user and check_password_hash(user.password, data['password']):
        access_token = create_access_token(identity=user.id)
        return jsonify({"token": access_token}), 200
    return jsonify({"message": "Credenciales inválidas"}), 401

@app.route('/api/emotions', methods=['GET', 'POST'])
@jwt_required()
def handle_emotions():
    current_user_id = get_jwt_identity()
    
    if request.method == 'GET':
        date = request.args.get('date')
        if date:
            date_obj = datetime.strptime(date, '%Y-%m-%d').date()
            emotion = Emotion.query.filter_by(user_id=current_user_id, date=date_obj).first()
            if emotion:
                return jsonify({"emotion": emotion.emotion}), 200
            return jsonify({"message": "No se encontró emoción para esta fecha"}), 404
        else:
            emotions = Emotion.query.filter_by(user_id=current_user_id).all()
            return jsonify({"emotions": [{"date": e.date.isoformat(), "emotion": e.emotion} for e in emotions]}), 200
    
    elif request.method == 'POST':
        data = request.json
        date_obj = datetime.strptime(data['date'], '%Y-%m-%d').date()
        emotion = Emotion.query.filter_by(user_id=current_user_id, date=date_obj).first()
        if emotion:
            emotion.emotion = data['emotion']
        else:
            new_emotion = Emotion(user_id=current_user_id, date=date_obj, emotion=data['emotion'])
            db.session.add(new_emotion)
        try:
            db.session.commit()
            return jsonify({"message": "Emoción guardada exitosamente"}), 201
        except:
            db.session.rollback()
            return jsonify({"message": "Error al guardar la emoción"}), 400

if __name__ == '__main__':
    app.run(debug=True) 