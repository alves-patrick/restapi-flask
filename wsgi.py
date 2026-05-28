from application import create_app
import os

if os.getenv("FLASK_ENV") == "development":
    # O Flask agora sabe exatamente onde achar: dentro da pasta application!
    app = create_app("config.DevConfig")
else:
    app = create_app("config.ProdConfig")


if __name__ == "__main__":
    app_host = os.getenv("FLASK_HOST", "0.0.0.0")
    app_port = int(os.getenv("PORT", 5000))

    app.run(debug=True, host=app_host, port=app_port)
