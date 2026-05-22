import os
from application import create_app 

if os.getenv('FLASK_ENV') == "development":
    # O Flask agora sabe exatamente onde achar: dentro da pasta application!
    app = create_app('application.config.DevConfig')
else: 
    app = create_app('application.config.ProdConfig')

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")