from flask import jsonify
from flask_restful import Resource, reqparse
from mongoengine import NotUniqueError
from .model import UserModel
import re
import json

_user_parser = reqparse.RequestParser()
_user_parser.add_argument('first_name', 
                          type=str,
                          required=True,
                          help="This field cannot be blank."
                          )
_user_parser.add_argument('last_name', 
                          type=str,
                          required=True,
                          help="This field cannot be blank."
                          )
_user_parser.add_argument('cpf', 
                          type=str,
                          required=True,
                          help="This field cannot be blank."
                          )
_user_parser.add_argument('email', 
                          type=str,
                          required=True,
                          help="This field cannot be blank."
                          )
_user_parser.add_argument('birth_date', 
                          type=str,
                          required=True,
                          help="This field cannot be blank."
                          )


# Seguindo a doc: definindo o modelo sem usar "db." na frente de nada

class Users(Resource):
    def get(self):
        #return jsonify(UserModel.objects())
        # 1. Pega os dados do banco e converte para texto
        dados_em_texto = UserModel.objects().to_json()
        
        # 2. Transforma o texto em uma lista normal do Python
        lista_de_usuarios = json.loads(dados_em_texto)
        
        # 3. Agora você pode usar o jsonify perfeitamente!
        return jsonify(lista_de_usuarios)
        

class User(Resource):
      
    def validate_cpf(self, cpf):

        # Has the correct mask?
        if not re.match(r'\d{3}\.\d{3}\.\d{3}-\d{2}', cpf):
            return False

        # Grab only numbers
        numbers = [int(digit) for digit in cpf if digit.isdigit()]

        # Does it have 11 digits?
        if len(numbers) != 11 or len(set(numbers)) == 1:
            return False

        # Validate first digit after -
        sum_of_products = sum(a*b for a, b in zip(numbers[0:9],
                                                  range(10, 1, -1)))
        expected_digit = (sum_of_products * 10 % 11) % 10
        if numbers[9] != expected_digit:
            return False

        # Validate second digit after -
        sum_of_products = sum(a*b for a, b in zip(numbers[0:10],
                                                  range(11, 1, -1)))
        expected_digit = (sum_of_products * 10 % 11) % 10
        if numbers[10] != expected_digit:
            return False

        return True
    
    def post(self):
        data = _user_parser.parse_args()
            
        if not self.validate_cpf(data["cpf"]):
                return {"message": "CPF is invalid!"}, 400

        try:    
            response = UserModel(**data).save()
            return {"message": "User %s sucessfully created!" % response.id}
        except NotUniqueError:
            return {"message": "CPF already exists in database!"}, 400


    def get(self, cpf):
      # 1. Pega os dados do Mongo e converte pra texto
        dados_em_texto = UserModel.objects(cpf=cpf).to_json()
        
        # 2. Converte pra lista do Python (se não achar, vira uma lista vazia [])
        usuario_lista = json.loads(dados_em_texto)
        
        # 3. Como mostrar a mensagem se não existir:
        # Se a lista estiver vazia (not usuario_lista), cai nesse if!
        if not usuario_lista:
            return {"message": "User does not exist in database!"}, 404
            
        # 4. Se chegou aqui, é porque achou! Devolve o primeiro usuário da lista
        return jsonify(usuario_lista[0])



 