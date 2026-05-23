import os

class DevConfig():
    MONGODB_SETTINGS = {
        'db': os.getenv('MONGODB_DB'),
        'host': os.getenv('MONGODB_HOST'),
        'username': os.getenv('MONGODB_USER'),
        'password': os.getenv('MONGODB_PASSWORD')
    }

class ProdConfig:

    MONGODB_USER = os.getenv('MONGODB_USER')
    MONGODB_PASSWORD = os.getenv('MONGODB_PASSWORD')
    MONGODB_HOST = os.getenv('MONGODB_HOST')
    MONGODB_DB = os.getenv('MONGODB_DB')

    MONGODB_SETTINGS = {
        'host': 'mongodb+srv://%s:%s@%s/%s?appName=Cluster0' % (
          MONGODB_USER,
          MONGODB_PASSWORD,
          MONGODB_HOST,
          MONGODB_DB
        )
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