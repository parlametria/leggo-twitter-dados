FROM python:3.8.5-alpine3.12

WORKDIR /code

RUN apk --update add postgresql-client && rm -rf /var/cache/apk/*

COPY ./requirements.txt /code/scripts/requirements.txt

RUN set -ex && \
    apk update && apk add --no-cache curl tzdata libpq && \    
    apk update \
    python -m pip --no-cache install -U pip && \
    python -m pip --no-cache install -r /code/scripts/requirements.txt

COPY . .

CMD echo "Imagem do feed-leggo-twitter atualizada"
