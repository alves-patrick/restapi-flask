import os

class DevConfig():
    MONGODB_SETTINGS = {
        'db': os.getenv('MONGODB_DB'),
        'host': os.getenv('MONGODB_HOST'),
        'username': os.getenv('MONGODB_USER'),
        'password': os.getenv('MONGODB_PASSWORD')
    }

class MockConfig:
    TESTING = True
    MONGODB_SETTINGS = {
        'db': 'users_test_db', 
        'host': 'localhost',   
        'port': 27017,
        'username': 'admin',
        'password': 'admin'
    }