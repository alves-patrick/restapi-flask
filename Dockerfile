FROM python:3.14.4-alpine3.23

EXPOSE 5000

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY application application
COPY wsgi.py config.py ./


CMD [ "python", "wsgi.py" ]