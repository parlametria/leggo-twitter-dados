FROM python:3.8.10-slim-buster

WORKDIR /crawler

RUN apt-get update
RUN apt-get install -y git

COPY ./requirements.txt /crawler/requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

CMD echo "Imagem do feed-leggo-twitter atualizada"
