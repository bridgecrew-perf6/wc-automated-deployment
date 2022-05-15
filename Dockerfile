FROM python:3.10-alpine

WORKDIR /usr/src/app

COPY word_count .

CMD [ "python", "./main.py" ]