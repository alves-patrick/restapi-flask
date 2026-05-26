import os
import mongomock


class DevConfig:
    MONGODB_SETTINGS = {
        "db": os.getenv("MONGODB_DB"),
        "host": os.getenv("MONGODB_HOST"),
        "username": os.getenv("MONGODB_USER"),
        "password": os.getenv("MONGODB_PASSWORD"),
    }


class ProdConfig:
    MONGODB_USER = os.getenv("MONGODB_USER")
    MONGODB_PASSWORD = os.getenv("MONGODB_PASSWORD")
    MONGODB_HOST = os.getenv("MONGODB_HOST")
    MONGODB_DB = os.getenv("MONGODB_DB")

    MONGODB_SETTINGS = {
        "host": (
            f"mongodb+srv://{MONGODB_USER}:{MONGODB_PASSWORD}@"
            f"{MONGODB_HOST}/{MONGODB_DB}?appName=Cluster0"
        )
    }


class MockConfig:
    TESTING = True
    MONGODB_SETTINGS = {
        "db": "mongoenginetest",
        "host": "mongodb://localhost",
        "mongo_client_class": mongomock.MongoClient,
    }
