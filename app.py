from flask import Flask
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

class Users(Resource):
    def get(self):
        return {"message": "user1"}

class User(Resource):
    def post(self):
        return {"message": "teste"}
    
    def get(self, cpf):
        return {"message": "CPF"}

api.add_resource(Users, '/Users')
api.add_resource(User, '/User', '/user/<string:cpf>')


if __name__ == '__main__':
    app.run(debug=True)