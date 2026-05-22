from flask import Flask 
from flask_restful import Resource, Api
# Seguindo a doc: importando tudo direto da biblioteca!
from mongoengine import connect, Document, StringField, EmailField, DateTimeField

app = Flask(__name__)
api = Api(app)

# Seguindo a doc: conexão direta
connect(
    db='users',
    port=27017,
    host='mongodb',
    username='admin',
    password='admin'
)

# Seguindo a doc: definindo o modelo sem usar "db." na frente de nada
class UserModel(Document):
    cpf = StringField(required=True, unique=True)
    first_name = StringField(require=True)
    last_name = StringField(required=True)
    email = EmailField(required=True)
    birth_date = DateTimeField(required=True)

class Users(Resource):
    def get(self):
        return UserModel.objects().to_json()
        return json.loads(usuarios_json)
        #return {"message": "user1"}

class User(Resource):
    def post(self):
        return {"message": "teste"}
    
    def get(self, cpf):
        return {"message": "CPF"}

api.add_resource(Users, '/users')
api.add_resource(User, '/user', '/user/<string:cpf>')

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")